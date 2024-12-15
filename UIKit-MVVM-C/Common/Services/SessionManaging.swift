//
//  SessionManaging.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Combine

// The SessionManaging protocol defines the responsibilities of a session manager.
// It provides properties and methods for handling user authentication and session state.
protocol SessionManaging {

    // The currently authenticated user, if any.
    var currentUser: User? { get }

    // A publisher that emits changes to the currentUser.
    // Subscribers can observe changes to the current user in real time.
    var currentUserPublisher: AnyPublisher<User?, Never> { get }

    // A Boolean value indicating whether the user is signed in.
    var isSignedIn: Bool { get }

    // A publisher that emits changes to the user's signed-in state.
    // Subscribers can observe whether the user is signed in or out.
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    
    // Signs in a user with the given email and password.
    // - Parameters:
    //   - email: The user's email address.
    //   - password: The user's password.
    // - Returns: A publisher that emits the signed-in user or an error if the sign-in fails.
    func signIn(email: String, password: String) -> AnyPublisher<User, Error>

    // Signs out the current user, effectively ending the session.
    func signOut()

    // Deletes the user's data from the keychain on the first app launch.
    func deleteUserFromKeychainOnFirstLaunch()
}
