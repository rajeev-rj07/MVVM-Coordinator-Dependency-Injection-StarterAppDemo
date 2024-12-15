//
//  ForgotPasswordCoordinator.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 14/12/24.
//

import UIKit
import Swinject

// ForgotPasswordCoordinator manages the flow for the forgot password process.
// It is responsible for presenting the forgot password screen and handling its completion.
final class ForgotPasswordCoordinator: ViewControllerCoordinator {

    // Dependency injection container for resolving services and dependencies.
    var container: Container

    // Navigation controller to manage view transitions, particularly for presenting and dismissing the forgot password screen.
    var navigationController: UINavigationController

    // A weak reference to the ForgotPasswordViewController to prevent strong reference cycles and memory leaks.
    weak var forgotPasswordViewController: ForgotPasswordViewController?

    // A closure that is executed when this coordinator finishes its job.
    // Typically used to notify a parent coordinator that the forgot password flow is complete.
    var finishAction: (ViewControllerCoordinator) -> Void

    // Destructor for ForgotPasswordCoordinator, called when it is deallocated.
    // Useful for debugging and tracking memory management.
    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    // Initializer for ForgotPasswordCoordinator.
    // - Parameters:
    //   - container: The Swinject container used for dependency injection.
    //   - navigationController: The UINavigationController that manages view navigation.
    //   - finishAction: A closure called when the coordinator finishes its flow.
    init(container: Swinject.Container, navigationController: UINavigationController, finishAction: @escaping (ViewControllerCoordinator) -> Void) {
        self.container = container
        self.navigationController = navigationController
        self.finishAction = finishAction
    }

    // Starts the forgot password flow by instantiating and presenting the ForgotPasswordViewController in a new UINavigationController.
    func start() {
        // Instantiate the ForgotPasswordViewController.
        let forgotPasswordViewController = ForgotPasswordViewController.instantiate()
        forgotPasswordViewController.delegate = self // Set the coordinator as the delegate to handle actions from the view.

        // Create a new UINavigationController to present the ForgotPasswordViewController modally.
        let navController = UINavigationController(rootViewController: forgotPasswordViewController)
        navController.modalPresentationStyle = .fullScreen // Present the forgot password flow in full screen.

        // Present the forgot password screen modally.
        navigationController.present(navController, animated: true)

        // Keep a reference to the forgot password view controller to manage its lifecycle.
        self.forgotPasswordViewController = forgotPasswordViewController
    }
}

// MARK: - ForgotPasswordViewControllerDelegate
// Conforms to the ForgotPasswordViewControllerDelegate protocol to handle events from the forgot password view controller.
extension ForgotPasswordCoordinator: ForgotPasswordViewControllerDelegate {

    // Called when the user finishes or cancels the forgot password flow.
    func dismiss() {
        // Dismiss the presented ForgotPasswordViewController.
        navigationController.dismiss(animated: true) { [weak self] in
            // Once dismissed, execute the finishAction closure to notify the parent coordinator.
            guard let self = self else { return }
            self.finishAction(self)
        }
    }
}
