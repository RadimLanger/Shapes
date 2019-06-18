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
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

