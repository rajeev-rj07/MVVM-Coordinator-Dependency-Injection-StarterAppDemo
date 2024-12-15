//
//  UIView+RandomGradientBackground.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit

extension UIView {

    func setRandomGradientBackground() {
        // Generate two random colors
        let color1 = UIColor.random
        let color2 = UIColor.random

        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        // Set the gradient layer to the view's bounds
        gradientLayer.frame = self.bounds

        // Insert the gradient layer below the view's layer
        if let currentLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            currentLayer.removeFromSuperlayer() // Remove existing gradient layer if exists
        }
        self.layer.insertSublayer(gradientLayer, at: 0)

        // Ensure the gradient layer resizes correctly when the view's bounds change
        self.layoutIfNeeded()
    }
}

extension UIColor {
    // Generate a random UIColor
    static var random: UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(256)) / 255.0,
            green: CGFloat(arc4random_uniform(256)) / 255.0,
            blue: CGFloat(arc4random_uniform(256)) / 255.0,
            alpha: 1.0
        )
    }
}
