//
//  AppCoordinator.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit
import Swinject

// AppCoordinator is responsible for managing the main flow of the application.
// It decides whether to launch the onboarding flow, sign-in flow, or the main app, based on the app's state.
// It also handles navigation between different parts of the app using child coordinators.
final class AppCoordinator: ViewControllerCoordinator {

    // A closure that is executed when this coordinator finishes its job.
    // Typically used to inform a parent coordinator that this coordinator is done.
    var finishAction: (ViewControllerCoordinator) -> Void

    // Swinject dependency injection container, used to resolve dependencies across the app.
    var container = Container()

    // A list of child coordinators, allowing the AppCoordinator to manage multiple flows at once.
    var childCoordinators = [ViewControllerCoordinator]()

    // The navigation controller that is used for managing the view hierarchy and navigating between screens.
    var navigationController: UINavigationController

    // Session manager handles the user's session (e.g., whether the user is signed in).
    // It's lazily resolved from the dependency container.
    private lazy var sessionManager: SessionManaging = container.resolve(SessionManaging.self)!

    // Tracks whether the onboarding process has been completed by the user.
    // Uses the @UserDefaultBool property wrapper to persist this value in UserDefaults.
    @UserDefaultBool(key: "onboardingCompleted", defaultValue: false)
    private var onboardingCompleted: Bool

    // Destructor for AppCoordinator, called when it is deallocated.
    // Useful for debugging and tracking memory management.
    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    // Initializer for the AppCoordinator.
    // - Parameters:
    //   - navigationController: The UINavigationController to use for navigation.
    //   - finishAction: A closure to be called when the coordinator finishes its flow.
    init(navigationController: UINavigationController, finishAction: @escaping (ViewControllerCoordinator) -> Void) {
        self.finishAction = finishAction
        self.navigationController = navigationController
        // Add required observers to listen
        addObservers()
    }

    // Starts the coordinator by determining the initial flow based on the onboarding state and session state.
    func start() {
        // Register all dependencies in the container.
        container.registerAll()
        // If the onboarding is not completed, start the onboarding flow.
        if !onboardingCompleted {
            sessionManager.deleteUserFromKeychainOnFirstLaunch() // Deletes the user's data from the keychain on the first app launch
            onboardingCompleted = true
            startOnboardingCoordinator()
        } else {
            // If the user is signed in, start the main app.
            // Otherwise, start the sign-in flow.
            if sessionManager.isSignedIn {
                startMainAppCoordinator()
            } else {
                startSignInCoordinator()
            }
        }
    }
}

// MARK: - Onboarding Flow
extension AppCoordinator {

    // Starts the onboarding flow using the OnboardingCoordinator.
    // Once the onboarding is complete, the coordinator is removed from the childCoordinators list.
    private func startOnboardingCoordinator() {
        let onboardingCoordinator = OnboardingCoordinator(
            container: container,
            navigationController: navigationController,
            finishAction: removeChildCoordinatorOnFinish
        )
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()

        // Keep a reference to the child coordinator to manage its lifecycle.
        self.childCoordinators.append(onboardingCoordinator)
    }
}

// Conformance to OnboardingCoordinatorDelegate, allowing communication from the onboarding flow.
extension AppCoordinator: OnboardingCoordinatorDelegate {

    // Called by the OnboardingCoordinator when the user needs to navigate to the sign-in screen.
    func navigateUserToSignIn() {
        startSignInCoordinator()
    }
}

// MARK: - Sign-In Flow
extension AppCoordinator {

    // Starts the sign-in flow using the SignInCoordinator.
    // Once the sign-in is complete, the coordinator is removed from the childCoordinators list.
    private func startSignInCoordinator() {
        let signInCoordinator = SignInCoordinator(
            container: container,
            navigationController: navigationController,
            finishAction: removeChildCoordinatorOnFinish
        )
        signInCoordinator.start()
        signInCoordinator.delegate = self

        // Keep a reference to the child coordinator to manage its lifecycle.
        self.childCoordinators.append(signInCoordinator)
    }
}

// Conformance to SignInCoordinatorDelegate, allowing communication from the sign-in flow.
extension AppCoordinator: SignInCoordinatorDelegate {

    // Called by the SignInCoordinator when the user has successfully signed in and needs to navigate to the home screen.
    func navigateUserToHome() {
        startMainAppCoordinator()
    }

    // Starts the main app flow using the MainAppCoordinator, which manages the primary features of the app.
    private func startMainAppCoordinator() {
        // Initializes and starts the main app coordinator (e.g., Home screen).
        let mainAppCoordinator = MainAppCoordinator(
            container: container,
            navigationController: navigationController,
            finishAction: removeChildCoordinatorOnFinish
        )
        mainAppCoordinator.start()

        // Keep a reference to the child coordinator to manage its lifecycle.
        self.childCoordinators.append(mainAppCoordinator)
    }
}

// MARK: - Helper Methods
extension AppCoordinator {

    // Removes a child coordinator from the list when it has finished its flow.
    // This is necessary to prevent memory leaks and properly manage the lifecycle of the coordinators.
    func removeChildCoordinatorOnFinish(_ coordinator: ViewControllerCoordinator) {
        // Find the index of the finished coordinator and remove it from the childCoordinators array.
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension AppCoordinator {
    // Adds observers to listen for specific notifications, particularly when the user logs in.
    // This allows the coordinator to reset and restart the flow upon login.
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetAppCoordinator),
                                               name: .userDidLogin,
                                               object: nil)
    }

    // Called when the userDidLogin notification is received. This method resets the app's state
    // by signing out the current session and restarting the coordinator.
    @objc private func resetAppCoordinator() {
        sessionManager.signOut()  // Signs out the current user session.
        childCoordinators.removeAll()  // Removes all child coordinators and reset the whole app flow.
        start()  // Restarts the coordinator to reload the app flow.
    }
}
