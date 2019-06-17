//
//  Collection+SafeSubscripting.swift
//  Shapes
//
//  Created by Radim Langer on 17/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
