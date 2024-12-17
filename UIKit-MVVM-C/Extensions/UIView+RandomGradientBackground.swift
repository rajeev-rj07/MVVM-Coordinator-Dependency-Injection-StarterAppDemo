//
//  UIView+RandomColor.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit
import SwiftUI

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
    
    static var randomDark: UIColor {
        return UIColor(
            red: CGFloat.random(in: 0.0...0.3),
            green: CGFloat.random(in: 0.0...0.3),
            blue: CGFloat.random(in: 0.0...0.3),
            alpha: 1.0
        )
    }
}

extension Color {
    // Generate a random UIColor
    static var random: UIColor {
        return UIColor(
            red: CGFloat(arc4random_uniform(256)) / 255.0,
            green: CGFloat(arc4random_uniform(256)) / 255.0,
            blue: CGFloat(arc4random_uniform(256)) / 255.0,
            alpha: 1.0
        )
    }
    
    static var randomDark: UIColor {
        return UIColor(
            red: CGFloat.random(in: 0.0...0.3),
            green: CGFloat.random(in: 0.0...0.3),
            blue: CGFloat.random(in: 0.0...0.3),
            alpha: 1.0
        )
    }
}
