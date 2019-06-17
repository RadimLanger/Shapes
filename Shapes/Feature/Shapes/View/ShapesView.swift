//
//  ShapesView.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class ShapesView: UIView {

    let button = UIButton(type: .infoDark) //todo: delete

    private var allShapeViews: [CAShapeLayer] {
        return [circleLayer, triangleLayer, starLayer].compactMap({ $0 })
    }
    
    private var randomColor: UIColor? {
        let colors: [UIColor] = [.red, .green, .blue, .orange, .brown, .yellow, .purple]
        return colors.randomElement()
    }

    private(set) var circleLayer: CAShapeLayer?
    private(set) var triangleLayer: CAShapeLayer?
    private(set) var starLayer: CAShapeLayer?

    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .white
        addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private let topBottomPadding: CGFloat = 16
    private let shapesVerticalPadding: CGFloat = 8
    private let shapesCount: CGFloat = 3
    private var spacingBetweenShapesPlusTopAndBottom: CGFloat {
        return (2 * topBottomPadding) + (shapesVerticalPadding * (shapesCount - 1))
    }
    private var shapeSize: CGSize {
        let size = (frame.size.height - spacingBetweenShapesPlusTopAndBottom) / shapesCount
        return CGSize(width: size, height: size)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard allShapeViews.isEmpty == false else { return }

        let shapeSize = self.shapeSize

        allShapeViews.enumerated().forEach({ index, shapeView in
            shapeView.frame.size = shapeSize

            let yPosition: CGFloat

            if let lastViewMaxY = allShapeViews[safe: index - 1]?.frame.maxY {
                yPosition = lastViewMaxY + shapesVerticalPadding
            } else {
                yPosition = topBottomPadding
            }

            shapeView.frame.origin.x = center.x - shapeSize.width / 2
            shapeView.frame.origin.y = yPosition
        })

        button.frame = CGRect(x: 15, y: 50, width: 50, height: 50)
    }

    func setupShapes() {

        let shapeSize = self.shapeSize
        let frame = CGRect(origin: .zero, size: shapeSize)
        circleLayer = CAShapeLayer.oval(for: frame)
        triangleLayer = CAShapeLayer.triangle(for: frame)
        starLayer = CAShapeLayer.star(for: frame)

        allShapeViews.forEach({
            layer.addSublayer($0)
            $0.fillColor = randomColor?.cgColor
        })
        setNeedsLayout()
    }

    @objc func buttonTapped() {
        animateOpacity()
    }

    func animateRotation() { // todo: transform.scale.x and y animation
        let shape = allShapeViews[1]

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 1.0

        shape.add(rotationAnimation, forKey: nil)
    }

    func animateOpacity() {
        guard let shape = allShapeViews.first else { return }
        let colorAnimation = CABasicAnimation(keyPath: "opacity")
        colorAnimation.fromValue = shape.opacity
        colorAnimation.toValue = [0.1, 0.5, 0.8, 1].randomElement()
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.duration = CFTimeInterval(integerLiteral: 1)
        colorAnimation.delegate = self
        shape.add(colorAnimation, forKey: nil)

    }
}

extension ShapesView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        let color = (anim as? CABasicAnimation)?.toValue as! CGColor
//        allShapeViews.first?.fillColor = color
    }
}
