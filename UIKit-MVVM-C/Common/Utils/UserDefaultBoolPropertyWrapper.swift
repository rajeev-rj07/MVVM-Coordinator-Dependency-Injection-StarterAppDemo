//
//  UserDefaultBoolPropertyWrapper.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation

@propertyWrapper
struct UserDefaultBool {
    let key: String
    let defaultValue: Bool
    private let userDefaults = UserDefaults.standard

    var wrappedValue: Bool {
        get {
            return userDefaults.bool(forKey: key)
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
