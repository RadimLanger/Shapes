//
//  Colors.swift
//  Shapes
//
//  Created by Radim Langer on 19/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

enum Color: String {

    case background = "Background"

    var value: UIColor {
        guard let color = UIColor(named: rawValue) else { fatalError("Non existing color") }
        return color
    }
}
