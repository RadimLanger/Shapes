//
//  ShapesViewController.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class ShapesViewController: UIViewController {

    enum Quadrant {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight

        static func translate(isInTopQuadrant: Bool, isInLeftQuadrant: Bool) -> Quadrant {
            switch (isInTopQuadrant, isInLeftQuadrant) {
                case (true, true):  return .topLeft
                case (false, true):  return .bottomLeft
                case (true, false):  return .topRight
                case (false, false):  return .bottomRight
            }
        }
    }

    private let rootView = ShapesView()

    private(set) lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDetected))

    private var lastLevitatingButtonQuadrant = Quadrant.bottomRight

    private var animateShapeForLastQuadrant: (CAShapeLayer) -> Void {
        switch lastLevitatingButtonQuadrant {
            case .topLeft, .topRight: return rootView.animateSize
            case .bottomLeft:         return rootView.animateOpacity
            case .bottomRight:        return rootView.animateRotation
        }
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootView.setupShapes()
        rootView.finishDraggingLevitatingButton(for: lastLevitatingButtonQuadrant, animated: false)

        setupMenuItems()
        view.setNeedsLayout()
    }

    private func setupMenuItems() {

        let shapeSize = rootView.shapeSize

        let circleImage = rootView.circleLayer?.render(for: shapeSize)
        let triangleImage = rootView.triangleLayer?.render(for: shapeSize)
        let starImage = rootView.starLayer?.render(for: shapeSize)

        let circleButton = UIButton(defaultImage: circleImage)
        circleButton.addTargetClosure { [weak self] _ in
            guard let circleLayer = self?.rootView.circleLayer else { return }
            self?.animateShapeForLastQuadrant(circleLayer)
        }

        let triangleButton = UIButton(defaultImage: triangleImage)
        triangleButton.addTargetClosure { [weak self] _ in
            guard let triangleLayer = self?.rootView.triangleLayer else { return }
            self?.animateShapeForLastQuadrant(triangleLayer)
        }

        let starButton = UIButton(defaultImage: starImage)
        starButton.addTargetClosure { [weak self] _ in
            guard let starLayer = self?.rootView.starLayer else { return }
            self?.animateShapeForLastQuadrant(starLayer)
        }

        rootView.levitatingMenuView.menuItems = [circleButton, triangleButton, starButton]
    }

    // MARK: Gesture handling

    @objc private func panGestureDetected(_ panRecognizer: UIPanGestureRecognizer) {

        let locationInRootView = panRecognizer.location(in: rootView)

        switch panRecognizer.state {
    
            case .began, .changed:
                rootView.interact(with: locationInRootView)

            case .failed, .ended, .cancelled:

                let isInTopQuadrant = locationInRootView.y < view.center.y
                let isInLeftQuadrant = locationInRootView.x < view.center.x
                let quadrant = Quadrant.translate(isInTopQuadrant: isInTopQuadrant, isInLeftQuadrant: isInLeftQuadrant)
                lastLevitatingButtonQuadrant = quadrant
                rootView.finishDraggingLevitatingButton(for: quadrant)
            default:
                break
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private extension CAShapeLayer {

    func render(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { context in
            return render(in: context.cgContext)
        }

        return image
    }
}

private extension UIButton {
    convenience init(defaultImage: UIImage?) {
        self.init()
        setImage(defaultImage, for: .normal)
    }
}
