//
//  CAShapeLayer+Shapes.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

extension CAShapeLayer {

    static func triangle(for frame: CGRect) -> CAShapeLayer {

        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()

        path.move(to: CGPoint(x: frame.minX, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
        path.addLine(to: CGPoint(x: (frame.maxX / 2.0), y: frame.minY))
        path.close()
        
        shapeLayer.path = path.cgPath

        return shapeLayer
    }

    static func oval(for frame: CGRect) -> CAShapeLayer {

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(ovalIn: frame).cgPath

        return shapeLayer
    }

    static func star(for frame: CGRect) -> CAShapeLayer {

        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()

        let xCenter = frame.height / 2
        let yCenter = frame.width / 2

        let size = max(frame.width, frame.height)
        let r = size / 2.0
        let flip: CGFloat = -1.0 // use this to flip the figure 1.0 or -1.0

        let polySide = CGFloat(5)

        let theta = 2.0 * Double.pi * Double(2.0 / polySide)

        path.move(to: CGPoint(x: xCenter, y: r * flip + yCenter))

        for index in 1 ..< Int(polySide) {
            let x: CGFloat = r * CGFloat( sin(Double(index) * theta) )
            let y: CGFloat = r * CGFloat( cos(Double(index) * theta) )
            path.addLine(to: CGPoint(x: x + xCenter, y: y * flip + yCenter))
        }

        path.close()

        shapeLayer.path = path.cgPath

        return shapeLayer
    }

}
