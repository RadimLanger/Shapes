//
//  ShapesView.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class ShapesView: UIView {

    var allShapeViews: [CAShapeLayer] {
        return [circleLayer, triangleLayer, starLayer].compactMap({ $0 })
    }

    let levitatingMenuView = LevitatingMenuView()

    private(set) var circleLayer: CAShapeLayer?
    private(set) var triangleLayer: CAShapeLayer?
    private(set) var starLayer: CAShapeLayer?

    private var levitationInteractionEnabled = false

    init() {
        super.init(frame: .zero)
        backgroundColor = Color.background.value

        addSubview(levitatingMenuView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var shapeSize: CGSize {
        let size = (frame.size.height - spacingBetweenShapesPlusTopAndBottom) / shapesCount
        return CGSize(width: size, height: size)
    }

    private let topBottomPadding: CGFloat = 16
    private let shapesVerticalPadding: CGFloat = 8
    private let shapesCount: CGFloat = 3
    private var spacingBetweenShapesPlusTopAndBottom: CGFloat {
        return (2 * topBottomPadding) + (shapesVerticalPadding * (shapesCount - 1))
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
    }

    func setupShapes() {

        let shapeSize = self.shapeSize
        let frame = CGRect(origin: .zero, size: shapeSize)
        circleLayer = CAShapeLayer.oval(for: frame)
        triangleLayer = CAShapeLayer.triangle(for: frame)
        starLayer = CAShapeLayer.star(for: frame)

        allShapeViews.forEach({ layer.insertSublayer($0, at: 0) })

        circleLayer?.fillColor = UIColor.red.cgColor
        triangleLayer?.fillColor = UIColor.blue.cgColor
        starLayer?.fillColor = UIColor.orange.cgColor
    }

    @objc func buttonTapped() {
        animateSize(for: circleLayer!)
        animateOpacity(for: triangleLayer!)
        animateRotation(for: starLayer!)
    }

    func interact(with fingerPosition: CGPoint) {
        guard levitatingMenuView.frame.contains(fingerPosition) || levitationInteractionEnabled else { return }
        levitationInteractionEnabled = true

        levitatingMenuView.center = fingerPosition
    }

    func finishDraggingLevitatingButton(for quadrant: ShapesViewController.Quadrant, animated: Bool = true) {

        levitationInteractionEnabled = false

        let halfExpandedButtonSize = LevitatingMenuView.expandedSize.width / 2
        let padding: CGFloat = 8

        let finalPoint: CGPoint

        let bottomLeftAnchorPoint = CGPoint(
            x: padding + halfExpandedButtonSize,
            y: frame.maxY - halfExpandedButtonSize - padding
        )
        let bottomRightAnchorPoint = CGPoint(
            x: frame.maxX - halfExpandedButtonSize - padding,
            y: frame.maxY - halfExpandedButtonSize - padding
        )
        let topRightAnchorPoint = CGPoint(
            x: frame.maxX - halfExpandedButtonSize - padding,
            y: padding + halfExpandedButtonSize
        )

        switch quadrant {
            case .topLeft, .topRight: finalPoint = topRightAnchorPoint
            case .bottomLeft:         finalPoint = bottomLeftAnchorPoint
            case .bottomRight:        finalPoint = bottomRightAnchorPoint
        }

        let animation = { self.levitatingMenuView.center = finalPoint }

        if animated {
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 1,
                options: [.curveEaseInOut],
                animations: animation,
                completion: nil
            )
        } else {
            animation()
        }
    }

    // MARK: - Animations

    func animateRotation(for layer: CAShapeLayer) {

        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 0.5
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
