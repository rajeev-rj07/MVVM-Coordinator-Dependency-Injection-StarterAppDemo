//
//  AuthenticationNetworkService.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Combine

final class AuthenticationNetworkService: AuthenticationNetworkServicing {

    let apiManager: APIManaging
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return CurrentValueSubject<User, Error>(User(id: "772682251", firstName: "Rajeev", lastName: "Kulariya", email: "dev.rajeev@gmail.com")).eraseToAnyPublisher()
        let target = AuthenticationTarget.signIn(email, password)
        return apiManager.request(target: target, responseType: User.self, jsonDecoder: nil)
    }

    func signUp(using model: SignUpModel) -> AnyPublisher<Bool, any Error> {
        let target = AuthenticationTarget.signUp(model)
        return apiManager.requestResponse(target: target)
            .tryMap { responseDict in
                guard let success = responseDict["success"] as? Bool else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return success
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func forgotPasswordOf(email: String) -> AnyPublisher<Bool, any Error> {
        let target = AuthenticationTarget.forgotPassword(email)
        return apiManager.requestResponse(target: target)
            .tryMap { responseDict in
                guard let success = responseDict["success"] as? Bool else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return success
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func logout() -> AnyPublisher<Bool, any Error> {
        let target = AuthenticationTarget.logout
        return apiManager.requestResponse(target: target)
            .tryMap { responseDict in
                guard let success = responseDict["success"] as? Bool else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return success
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
