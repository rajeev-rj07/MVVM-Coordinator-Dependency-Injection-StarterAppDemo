//
//  SignUpCoordinator.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 14/12/24.
//

import UIKit
import Swinject

// Protocol for communication between SignUpCoordinator and its delegate (likely a parent coordinator, such as AppCoordinator).
// It allows the coordinator to notify its delegate when the sign-up process is finished.
protocol SignUpCoordinatorDelegate: AnyObject {
    func finishedSignUp()
}

// SignUpCoordinator manages the flow of the sign-up process.
// It is responsible for presenting the sign-up screen and notifying its delegate when the process is complete.
final class SignUpCoordinator: ViewControllerCoordinator {

    // Dependency injection container for resolving services and dependencies.
    var container: Container

    // Navigation controller to manage view transitions, particularly for presenting and dismissing the sign-up screen.
    var navigationController: UINavigationController

    // A closure that is executed when this coordinator finishes its job.
    // Typically used to notify a parent coordinator that the sign-up flow is complete.
    var finishAction: (ViewControllerCoordinator) -> Void

    // A weak reference to the SignUpViewController to prevent retain cycles and memory leaks.
    weak var signUpViewController: SignUpViewController?

    // A weak reference to the delegate (typically AppCoordinator) to avoid strong reference cycles.
    // This delegate is notified when the sign-up process is complete.
    weak var delegate: SignUpCoordinatorDelegate?

    // Destructor for SignUpCoordinator, called when it is deallocated.
    // Useful for debugging and tracking memory management.
    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    // Initializer for SignUpCoordinator.
    // - Parameters:
    //   - container: The Swinject container used for dependency injection.
    //   - navigationController: The UINavigationController that manages view navigation.
    //   - finishAction: A closure called when the coordinator finishes its flow.
    init(container: Container, navigationController: UINavigationController, finishAction: @escaping (ViewControllerCoordinator) -> Void) {
        self.finishAction = finishAction
        self.navigationController = navigationController
        self.container = container
    }

    // Starts the sign-up flow by instantiating and presenting the SignUpViewController in a new UINavigationController.
    func start() {
        // Instantiate the SignUpViewController.
        let signUpViewController = SignUpViewController.instantiate()
        signUpViewController.delegate = self // Set the coordinator as the delegate to handle actions from the view.

        // Create a new UINavigationController to present the SignUpViewController modally.
        let navController = UINavigationController(rootViewController: signUpViewController)
        navController.modalPresentationStyle = .fullScreen // Present the sign-up flow in full screen.

        // Present the sign-up screen modally.
        navigationController.present(navController, animated: true)

        // Keep a reference to the sign-up view controller to manage its lifecycle.
        self.signUpViewController = signUpViewController
    }
}

// MARK: - SignUpViewControllerDelegate
// Conforms to the SignUpViewControllerDelegate protocol to handle events from the sign-up view controller.
extension SignUpCoordinator: SignUpViewControllerDelegate {

    // Called when the user cancels or dismisses the sign-up process.
    func dismiss() {
        // Dismiss the presented SignUpViewController.
        navigationController.dismiss(animated: true) { [weak self] in
            // Once dismissed, execute the finishAction closure to notify the parent coordinator.
            guard let self = self else { return }
            self.finishAction(self)
        }
    }

    // Called when the user successfully completes the sign-up process.
    func finishedSignUp() {
        // Notify the delegate (likely AppCoordinator) that the sign-up process is complete.
        delegate?.finishedSignUp()

        // Dismiss the sign-up flow.
        dismiss()
    }
}
