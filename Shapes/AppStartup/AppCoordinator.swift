//
//  AppCoordinator.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window = UIWindow(frame: UIScreen.main.bounds)

    func start() {
        window.rootViewController = ShapesViewController()
        window.makeKeyAndVisible()
    }
}
