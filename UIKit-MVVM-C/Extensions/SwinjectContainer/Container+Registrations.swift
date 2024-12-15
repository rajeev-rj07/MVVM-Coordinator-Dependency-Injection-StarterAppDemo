//
//  Container+SwinjectRegistration.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Swinject

extension Container {
    func registerAll() {
        registerServices()
        registerViewModels()
    }
}
