//
//  SignInCoordinator.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit
import Swinject

// Protocol to communicate between SignInCoordinator and its delegate (likely AppCoordinator).
// This allows the SignInCoordinator to notify its delegate when the user should be navigated to the home screen.
protocol SignInCoordinatorDelegate: AnyObject {
    func navigateUserToHome()
}

// SignInCoordinator handles the flow of the sign-in process.
// It is responsible for presenting the sign-in screen and optionally navigating to the home screen or other flows (sign-up, forgot password).
final class SignInCoordinator: ViewControllerCoordinator {

    // Dependency injection container for resolving services and dependencies.
    var container: Container

    // Navigation controller to manage view transitions during the sign-in flow.
    var navigationController: UINavigationController

    // Closure executed when this coordinator finishes its job.
    var finishAction: (ViewControllerCoordinator) -> Void

    // Weak reference to the sign-in view controller to avoid retain cycles.
    weak var signInViewController: SignInViewController?

    // Array to keep track of any child coordinators (e.g., SignUpCoordinator, ForgotPasswordCoordinator).
    var childCoordinators = [ViewControllerCoordinator]()

    // Weak reference to the delegate (likely AppCoordinator) to avoid strong reference cycles.
    weak var delegate: SignInCoordinatorDelegate?

    // Destructor for SignInCoordinator, prints debug information when it is deallocated.
    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    // Initializer for SignInCoordinator.
    // - Parameters:
    //   - container: The Swinject container used for dependency injection.
    //   - navigationController: The UINavigationController that manages view navigation.
    //   - finishAction: A closure called when the coordinator completes its flow.
    init(container: Container, navigationController: UINavigationController, finishAction: @escaping (ViewControllerCoordinator) -> Void) {
        self.finishAction = finishAction
        self.navigationController = navigationController
        self.container = container
    }

    // Starts the sign-in flow by pushing the SignInViewController onto the navigation stack.
    // If the navigation controller already contains view controllers, the first one is removed to avoid showing it again.
    func start() {
        // Instantiate the SignInViewController.
        let signInViewController = SignInViewController.instantiate()
        signInViewController.delegate = self // Set the coordinator as the delegate to handle events from the view.
        signInViewController.viewModel = container.resolve(SignInViewModel.self)

        // Push the SignInViewController onto the navigation stack.
        if navigationController.viewControllers.count > 0 {
            navigationController.pushViewController(signInViewController, animated: true)

            // Remove the first view controller from the stack to prevent navigating back to it.
            var viewControllers = navigationController.viewControllers
            viewControllers.remove(at: 0)
            navigationController.viewControllers = viewControllers
        } else {
            navigationController.pushViewController(signInViewController, animated: true)
        }

        // Keep a reference to the SignInViewController to manage its lifecycle.
        self.signInViewController = signInViewController
    }
}

// MARK: - SignInViewControllerDelegate
// Conforms to the SignInViewControllerDelegate protocol to handle events from the sign-in view controller.
extension SignInCoordinator: SignInViewControllerDelegate {

    // Called when the user successfully signs in and should be navigated to the home screen.
    func navigateUserToHome() {
        // Notify the delegate (likely AppCoordinator) to navigate the user to the home screen.
        self.delegate?.navigateUserToHome()

        // Finish the current sign-in coordinator's flow by executing the finishAction closure.
        finishAction(self)
    }
}

// MARK: - Handling Sign-Up Flow
extension SignInCoordinator {

    // Called when the user wants to navigate to the sign-up screen.
    func navigateUserToSignUp() {
        startSignUpCoordinator()
    }

    // Starts the sign-up flow by initializing and starting the SignUpCoordinator.
    private func startSignUpCoordinator() {
        // Create and start a new SignUpCoordinator.
        let signUpCoordinator = SignUpCoordinator(container: container, navigationController: navigationController, finishAction: removeChildCoordinatorOnFinish)
        signUpCoordinator.delegate = self // Set this coordinator as the delegate to handle sign-up flow completion.
        signUpCoordinator.start()

        // Add the sign-up coordinator to the child coordinators array for lifecycle management.
        self.childCoordinators.append(signUpCoordinator)
    }
}

// MARK: - Handling Forgot Password Flow
extension SignInCoordinator {

    // Called when the user wants to navigate to the forgot password screen.
    func navigateUserToForgotPassword() {
        startForgotPasswordCoordinator()
    }

    // Starts the forgot password flow by initializing and starting the ForgotPasswordCoordinator.
    private func startForgotPasswordCoordinator() {
        // Create and start a new ForgotPasswordCoordinator.
        let forgotPasswordCoordinator = ForgotPasswordCoordinator(container: container, navigationController: navigationController, finishAction: removeChildCoordinatorOnFinish)
        forgotPasswordCoordinator.start()

        // Add the forgot password coordinator to the child coordinators array for lifecycle management.
        self.childCoordinators.append(forgotPasswordCoordinator)
    }
}

// MARK: - SignUpCoordinatorDelegate
// Conforms to the SignUpCoordinatorDelegate protocol to handle sign-up flow completion.
extension SignInCoordinator: SignUpCoordinatorDelegate {

    // Called when the sign-up process is finished.
    func finishedSignUp() {
        // You could add logic here to handle post sign-up actions if needed.
    }
}

// MARK: - Managing Child Coordinators
extension SignInCoordinator {

    // Removes a child coordinator from the childCoordinators array when its flow is finished.
    // - Parameter coordinator: The coordinator to remove.
    func removeChildCoordinatorOnFinish(_ coordinator: ViewControllerCoordinator) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }
}
