//
//  Container+ViewModelRestration.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Swinject

extension Container {
    func registerViewModels() {
        register(SignInViewModel.self) { resolver in
            return SignInViewModel(sessionManager: resolver.resolve(SessionManaging.self)!)
        }
        register(HomeViewModel.self) { resolver in
            return HomeViewModel(sessionManager: resolver.resolve(SessionManaging.self)!)
        }
    }
}
