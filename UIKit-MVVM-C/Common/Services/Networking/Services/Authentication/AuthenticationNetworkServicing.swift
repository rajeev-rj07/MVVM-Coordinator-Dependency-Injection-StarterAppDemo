//
//  AuthenticationNetworkServicing.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Combine

protocol AuthenticationNetworkServicing {
    func signIn(email: String, password: String) -> AnyPublisher<User, Error>
    func signUp(using model: SignUpModel) -> AnyPublisher<Bool, Error>
    func forgotPasswordOf(email: String) -> AnyPublisher<Bool, Error>
    func logout() -> AnyPublisher<Bool, Error>
}
