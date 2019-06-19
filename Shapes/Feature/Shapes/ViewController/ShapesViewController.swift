//
//  ShapesViewController.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class ShapesViewController: UIViewController {

    private let rootView = ShapesView()

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootView.setupShapes()
        rootView.updateLevitatingMenuPosition()

        setupMenuItems()
        view.setNeedsLayout()
    }

    private func setupMenuItems() {

        let shapeSize = rootView.shapeSize

        let circleImage = rootView.circleLayer?.render(for: shapeSize)
        let triangleImage = rootView.triangleLayer?.render(for: shapeSize)
        let starImage = rootView.starLayer?.render(for: shapeSize)

        let circleButton = UIButton(defaultImage: circleImage)
        circleButton.addTargetClosure { _ in
            print("circle tapped")
        }

        let triangleButton = UIButton(defaultImage: triangleImage)
        triangleButton.addTargetClosure { _ in
            print("triangleImage tapped")
        }

        let starButton = UIButton(defaultImage: starImage)
        starButton.addTargetClosure { _ in
            print("starImage tapped")
        }

        rootView.levitatingMenuView.menuItems = [circleButton, triangleButton, starButton]
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
