//
//  AuthenticationNetworkService.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Combine

/// A concrete implementation of the `AuthenticationNetworkServicing` protocol.
/// Handles network operations related to authentication.
final class AuthenticationNetworkService: AuthenticationNetworkServicing {

    /// A manager responsible for performing API requests.
    private let apiManager: APIManaging

    /// Initializes the service with an API manager.
    /// - Parameter apiManager: The manager used for making network requests.
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }

    /// Sign in a user with email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A publisher that emits a `User` object on success or an `Error` on failure.
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        let subject = PassthroughSubject<User, Error>()

        // Simulating network request with a dummy user response (remove this when integrating real APIs).
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let user = User(id: "772682251", firstName: "Rajeev", lastName: "Kulariya", email: "dev.rajeev@gmail.com")
            subject.send(user)
        }
        return subject.eraseToAnyPublisher()
        #warning("Uncomment the following code and remove the dummy implementation once real APIs are integrated.")
        // let target = AuthenticationTarget.signIn(email, password)
        // return apiManager.request(target: target, responseType: User.self, jsonDecoder: nil)
    }

    /// Sign up a new user with the provided details in the model.
    /// - Parameter model: A `SignUpModel` containing user registration details.
    /// - Returns: A publisher that emits a `Bool` indicating whether the sign-up was successful.
    func signUp(using model: SignUpModel) -> AnyPublisher<Bool, Error> {
        let target = AuthenticationTarget.signUp(model)

        // Perform the network request to sign up the user and handle the response.
        return apiManager.requestResponse(target: target)
            .tryMap { responseDict in
                // Check if the response contains a success field.
                guard let success = responseDict["success"] as? Bool else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return success
            }
            .mapError { $0 as Error } // Convert any error to the expected Error type.
            .eraseToAnyPublisher() // Return a publisher that can be subscribed to.
    }

    /// Initiates a password reset process for the user with the provided email.
    /// - Parameter email: The email address for password reset.
    /// - Returns: A publisher that emits `Bool` indicating whether the password reset request was successful.
    func forgotPasswordOf(email: String) -> AnyPublisher<Bool, Error> {
        let target = AuthenticationTarget.forgotPassword(email)

        // Perform the network request to initiate the password reset process and handle the response.
        return apiManager.requestResponse(target: target)
            .tryMap { responseDict in
                // Check if the response contains a success field.
                guard let success = responseDict["success"] as? Bool else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return success
            }
            .mapError { $0 as Error } // Convert any error to the expected Error type.
            .eraseToAnyPublisher() // Return a publisher that can be subscribed to.
    }

    /// Log out the current user.
    /// - Returns: A publisher that emits `Bool` indicating whether the logout was successful.
    func logout() -> AnyPublisher<Bool, Error> {
        let target = AuthenticationTarget.logout

        // Perform the network request to log out the user and handle the response.
        return apiManager.requestResponse(target: target)
            .tryMap { responseDict in
                // Check if the response contains a success field.
                guard let success = responseDict["success"] as? Bool else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return success
            }
            .mapError { $0 as Error } // Convert any error to the expected Error type.
            .eraseToAnyPublisher() // Return a publisher that can be subscribed to.
    }
}
