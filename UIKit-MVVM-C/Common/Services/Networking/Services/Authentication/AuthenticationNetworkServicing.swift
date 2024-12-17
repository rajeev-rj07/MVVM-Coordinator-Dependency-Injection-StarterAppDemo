//
//  AuthenticationNetworkServicing.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Combine

/// Protocol defining authentication-related network operations.
protocol AuthenticationNetworkServicing {
    /// Sign in a user with email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A publisher that emits a `User` object on success or an `Error` on failure.
    func signIn(email: String, password: String) -> AnyPublisher<User, Error>

    /// Sign up a new user with a provided model.
    /// - Parameter model: A `SignUpModel` containing user details for registration.
    /// - Returns: A publisher that emits `Bool` indicating success or failure.
    func signUp(using model: SignUpModel) -> AnyPublisher<Bool, Error>

    /// Initiates a password reset process for the user by email.
    /// - Parameter email: The user's email address to initiate the password reset.
    /// - Returns: A publisher that emits `Bool` indicating success or failure.
    func forgotPasswordOf(email: String) -> AnyPublisher<Bool, Error>

    /// Log out the current user.
    /// - Returns: A publisher that emits `Bool` indicating success or failure of the logout process.
    func logout() -> AnyPublisher<Bool, Error>
}
