//
//  SessionManager.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import Foundation
import Combine
import Security

// The SessionManager class is responsible for managing the user's session.
// It handles user authentication, storing and retrieving user data from the Keychain, and publishing updates on the user's authentication state.
final class SessionManager: SessionManaging {

    // Constant for storing the user key in Keychain
    private static let userKey = "userKey"

    // Published property that holds the current user. It automatically publishes updates when the user changes.
    @Published private(set) var currentUser: User?

    // Exposes the currentUser as a publisher, allowing other parts of the app to subscribe to changes.
    var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }

    // Published property to track whether the user is signed in.
    @Published private(set) var isSignedIn: Bool = false

    // Exposes the isSignedIn state as a publisher to allow subscribing to authentication state changes.
    var isSignedInPublisher: AnyPublisher<Bool, Never> {
        $isSignedIn.eraseToAnyPublisher()
    }

    // Set of cancellable subscriptions used to manage Combine publishers.
    private var cancellables = Set<AnyCancellable>()

    // Service responsible for handling network authentication requests.
    private let authenticationNetworkService: AuthenticationNetworkServicing

    // Constructor that takes in an authentication network service and sets up bindings and loads the user from Keychain.
    init(authenticationNetworkService: AuthenticationNetworkServicing) {
        self.authenticationNetworkService = authenticationNetworkService
        bind() // Binds the Combine publishers.
        loadUser() // Loads the user data from Keychain if available.
    }

    // Binds Combine publishers to update the session state.
    private func bind() {
        // Updates the Keychain whenever the currentUser changes, ignoring the first 2 values to prevent premature updates during initialization.
        $currentUser
            .dropFirst(2)
            .removeDuplicates()
            .sink { [weak self] user in
                self?.saveUser(user)
            }
            .store(in: &cancellables)

        // Updates the isSignedIn property whenever currentUser is set, using map to convert user presence to a Boolean.
        $currentUser
            .map({ $0 != nil })
            .removeDuplicates()
            .assign(to: &$isSignedIn)
    }

    // Handles signing in by calling the network service and setting the user if successful.
    // - Parameters:
    //   - email: The user's email address.
    //   - password: The user's password.
    // - Returns: A publisher that either emits the signed-in user or an error.
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        authenticationNetworkService.signIn(email: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.currentUser = user // Set the currentUser when a user is successfully signed in.
            })
            .eraseToAnyPublisher()
    }
}

extension SessionManager {

    // Saves the user to Keychain securely using the native Keychain services.
    // - Parameter user: The user to be saved or nil to remove the user.
    private func saveUser(_ user: User?) {
        guard let user = user else {
            // If the user is nil, remove the data from the Keychain (i.e., user logged out).
            deleteFromKeychain()
            return
        }

        // Encode the User object to JSON and store it in the Keychain.
        do {
            let jsonData = try JSONEncoder().encode(user)
            let dataString = jsonData.base64EncodedString() // Convert data to base64 string for storage.
            setToKeychain(dataString)
        } catch {
            print("log - Error - Saving user to Keychain - \(error)")
        }
    }

    // Loads the user from the Keychain.
    // If user data exists, it is decoded and set as the current user. If not, the user is signed out.
    private func loadUser() {
        guard let dataString = getFromKeychain() else {
            signOut() // No data found, so sign the user out.
            return
        }

        do {
            // Convert the base64 string back to Data and decode it into a User object.
            guard let data = Data(base64Encoded: dataString) else {
                signOut() // If decoding fails, sign out the user.
                return
            }
            let user = try JSONDecoder().decode(User.self, from: data)
            currentUser = user // Set the current user.
        } catch {
            signOut() // On error, sign out the user and print the error.
            print("log - Error - Loading user from Keychain - \(error)")
        }
    }

    // Signs out the user by clearing the current user.
    func signOut() {
        currentUser = nil
    }

    // MARK: - Keychain Helper Methods

    // Adds or updates the user data in the Keychain.
    // - Parameter dataString: The base64-encoded string representation of the user data.
    private func setToKeychain(_ dataString: String) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Define the item class.
            kSecAttrAccount as String: Self.userKey,       // Store the data with the userKey identifier.
            kSecValueData as String: dataString.data(using: .utf8)!, // Store the data.
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock // Define accessibility options.
        ]

        // Delete any existing item to prevent duplicates.
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new item to the Keychain.
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)

        if status == errSecSuccess {
            print("log - User saved to Keychain successfully")
        } else {
            print("log - Error saving user to Keychain - Status: \(status)")
        }
    }

    // Retrieves the user data from the Keychain.
    // - Returns: A base64-encoded string representing the user data, or nil if no data is found.
    private func getFromKeychain() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Self.userKey,  // Query for the item using the userKey.
            kSecReturnData as String: kCFBooleanTrue!, // Return the data from Keychain.
            kSecMatchLimit as String: kSecMatchLimitOne // Only return one match.
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8) // Convert the data back to a string.
        } else {
            print("log - Error retrieving user from Keychain - Status: \(status)")
            return nil
        }
    }

    // Deletes the user data from the Keychain.
    private func deleteFromKeychain() {
        // Create a query to target the user data stored in the Keychain.
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Targeting a generic password item.
            kSecAttrAccount as String: Self.userKey        // Using the predefined userKey to identify the specific data.
        ]

        // Attempt to delete the item from the Keychain.
        let status = SecItemDelete(keychainQuery as CFDictionary)

        // Check the status of the deletion operation.
        if status == errSecSuccess {
            print("log - User deleted from Keychain successfully")
        } else {
            print("log - Error deleting user from Keychain - Status: \(status)")
        }
    }

    // This function deletes user data from the Keychain if it exists, usually triggered on the first app launch.
    func deleteUserFromKeychainOnFirstLaunch() {
        // Check if user data exists in the Keychain.
        guard let dataString = getFromKeychain() else {
            return // If no data is found, there's nothing to delete.
        }
        // If data exists, call the function to delete it from the Keychain.
        deleteFromKeychain()
    }
}
