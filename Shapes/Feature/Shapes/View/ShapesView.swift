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
    
    private func randomColor(filter color: UIColor) -> UIColor? { // todo: delete?

        let colors: [UIColor] = [.red, .blue, .orange, .brown, .yellow, .purple].filter({ $0 != color })
        return colors.randomElement()
    }

    private(set) var circleLayer: CAShapeLayer?
    private(set) var triangleLayer: CAShapeLayer?
    private(set) var starLayer: CAShapeLayer?

    convenience init() {
        self.init(frame: .zero)

        backgroundColor = UIColor(named: "Background")
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

        allShapeViews.forEach(layer.addSublayer)

        circleLayer?.fillColor = UIColor.red.cgColor
        triangleLayer?.fillColor = UIColor.blue.cgColor
        starLayer?.fillColor = UIColor.orange.cgColor

        setNeedsLayout()
    }

    @objc func buttonTapped() {
        animateSize(for: circleLayer!)
        animateOpacity(for: triangleLayer!)
        animateRotation(for: starLayer!)
    }

    func animateRotation(for layer: CAShapeLayer) {

        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0.0
        animation.toValue = Double.pi
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        layer.add(animation, forKey: nil)
    }

    func animateOpacity(for layer: CAShapeLayer) {

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fillMode = .forwards
        animation.duration = CFTimeInterval(floatLiteral: 0.3)
        let newLayerOpacity: Float = layer.opacity == 0.1 ? 1 : 0.1
        animation.fromValue = layer.opacity
        layer.opacity = newLayerOpacity

        layer.add(animation, forKey: nil)
    }

    func animateSize(for layer: CAShapeLayer) {

        let newValue: CGFloat = layer.affineTransform().a == 1 ? 0.8 : 1
        layer.setAffineTransform(CGAffineTransform(scaleX: newValue, y: newValue))
    }
}
