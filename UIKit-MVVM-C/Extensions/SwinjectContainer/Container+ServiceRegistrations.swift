//
//  Container+ServiceRegistrations.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Swinject

extension Container {
    func registerServices() {
        register(APIManaging.self) { resolver in
            APIManager()
        }
        .inObjectScope(.container)

        register(AuthenticationNetworkServicing.self) { resolver in
            AuthenticationNetworkService(apiManager: resolver.resolve(APIManaging.self)!)
        }
        .inObjectScope(.container)

        register(SessionManaging.self) { resolver in
            SessionManager(authenticationNetworkService: resolver.resolve(AuthenticationNetworkServicing.self)!)
        }
        .inObjectScope(.container)
    }
}
