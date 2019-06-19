//
//  LevitatingMenuView.swift
//  Shapes
//
//  Created by Radim Langer on 18/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import UIKit

final class LevitatingMenuView: UIView {

    static let preferredSize = CGSize(width: 65, height: 65)
    static let expandedSize = CGSize(width: 125, height: 125)

    enum MenuState {
        case identity
        case expanded

        var size: CGSize {
            switch self {
                case .identity: return LevitatingMenuView.preferredSize
                case .expanded: return LevitatingMenuView.expandedSize
            }
        }
    }

    var menuItems = [UIButton]() {
        didSet {
            // Right now i'll just expect 3 items to be in the menu
            oldValue.forEach { button in
                button.removeFromSuperview()
            }
            menuItems.forEach(addSubview)
            setupMenuItemsLayout(with: lastState)
        }
    }

    private let menuButton = UIButton(type: .infoLight)

    private var lastState = MenuState.identity

    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .green
        addSubview(menuButton)
        frame.size = LevitatingMenuView.preferredSize

        layer.cornerRadius = LevitatingMenuView.preferredSize.width / 2

        menuButton.addTargetClosure { [weak self] _ in
            let opposite: LevitatingMenuView.MenuState = self?.lastState == .expanded ? .identity : .expanded
            self?.lastState = opposite
            self?.setMenu(to: opposite)
        }
    }

    private let buttonSize: CGFloat = 50

    override func layoutSubviews() {
        super.layoutSubviews()

        menuButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
        updateButtonPosition()
    }

    private func updateButtonPosition() {
        menuButton.frame.origin.x = frame.width / 2 - buttonSize / 2
        menuButton.frame.origin.y = frame.height / 2 - buttonSize / 2
    }

    private func setupMenuItemsLayout(with state: MenuState) {
        switch state {
            case .identity:

                menuItems.forEach { button in
                    button.isUserInteractionEnabled = false
                    button.frame.size = .zero
                    button.frame.origin = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                }

            case .expanded:

                let menuButtonSize: CGFloat = 30
                menuItems.forEach { button in
                    button.isUserInteractionEnabled = true
                    button.frame.size = CGSize(width: menuButtonSize, height: menuButtonSize)
                }

                let padding: CGFloat = 8
                let positions: [CGPoint] = [
                    CGPoint(x: padding, y: bounds.height / 2 - menuButtonSize / 2),
                    CGPoint(x: bounds.maxX - menuButtonSize - padding, y: bounds.height / 2 - menuButtonSize / 2),
                    CGPoint(x: bounds.width / 2 - menuButtonSize / 2, y: bounds.maxY - menuButtonSize - padding)
                ]
                menuItems.enumerated().forEach { index, button in
                    button.frame.size = CGSize(width: 30, height: 30)
                    button.frame.origin = positions[index]
                }
        }
    }

    func setMenu(to state: MenuState) {
        UIView.animate(withDuration: 0.2, animations: {

            let centerDiff = self.centerDifference(for: state)

            self.frame.size = state.size
            self.frame.origin.x += centerDiff
            self.frame.origin.y += centerDiff
            self.updateButtonPosition()
            self.setupMenuItemsLayout(with: state)
        })

        animateChangingCornerRadius(state: state, duration: 0.2)
    }

    private func centerDifference(for state: MenuState) -> CGFloat {
        let difference = (LevitatingMenuView.expandedSize.width - LevitatingMenuView.preferredSize.width) / 2

        switch state {
            case .identity: return difference
            case .expanded: return -difference
        }
    }

    private func animateChangingCornerRadius(state: MenuState, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut) // todo: sjednoceni animaci
        animation.fromValue = layer.cornerRadius
        animation.duration = duration
        layer.cornerRadius = state.size.width / 2
        layer.add(animation, forKey: "cornerRadius")
    }
}
