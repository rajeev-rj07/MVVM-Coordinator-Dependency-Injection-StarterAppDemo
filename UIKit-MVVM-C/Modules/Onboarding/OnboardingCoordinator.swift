//
//  OnboardingCoordinator.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit
import Swinject

// Protocol for communication between OnboardingCoordinator and its delegate (likely AppCoordinator).
// It allows the coordinator to notify its delegate when onboarding is finished, and the user should navigate to the sign-in flow.
protocol OnboardingCoordinatorDelegate: AnyObject {
    func navigateUserToSignIn()
}

// OnboardingCoordinator manages the flow of the onboarding process.
// It is responsible for presenting the onboarding screens and notifying its delegate when onboarding is complete.
final class OnboardingCoordinator: ViewControllerCoordinator {

    // Dependency injection container for resolving services and dependencies.
    var container: Container

    // The navigation controller to manage view transitions during the onboarding flow.
    var navigationController: UINavigationController

    // A closure that is executed when this coordinator finishes its job.
    // Typically used to notify a parent coordinator that the onboarding flow is complete.
    var finishAction: (ViewControllerCoordinator) -> Void

    // A weak reference to the onboarding view controller to prevent retain cycles.
    weak var onboardingViewController: OnboardingViewController?

    // A weak reference to the delegate (typically AppCoordinator) to avoid strong reference cycles.
    // This delegate is notified when the onboarding flow is complete.
    weak var delegate: OnboardingCoordinatorDelegate?

    // Destructor for OnboardingCoordinator, called when it is deallocated.
    // Useful for debugging and tracking memory management.
    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    // Initializer for OnboardingCoordinator.
    // - Parameters:
    //   - container: The Swinject container used for dependency injection.
    //   - navigationController: The UINavigationController that manages view navigation.
    //   - finishAction: A closure called when the coordinator finishes its flow.
    init(container: Container, navigationController: UINavigationController, finishAction: @escaping (ViewControllerCoordinator) -> Void) {
        self.navigationController = navigationController
        self.finishAction = finishAction
        self.container = container
    }

    // Starts the onboarding flow by instantiating and presenting the OnboardingViewController.
    func start() {
        let onboardingViewController = OnboardingViewController.instantiate()
        onboardingViewController.delegate = self // Set the coordinator as the delegate to handle actions from the view.
        navigationController.pushViewController(onboardingViewController, animated: true)

        // Keep a reference to the onboarding view controller to manage its lifecycle.
        self.onboardingViewController = onboardingViewController
    }
}

// MARK: - OnboardingViewControllerDelegate
// Conforms to the OnboardingViewControllerDelegate protocol to handle events from the onboarding view controller.
extension OnboardingCoordinator: OnboardingViewControllerDelegate {

    // Called when the user completes the onboarding process.
    func finishedOnboarding() {
        // Pop the OnboardingViewController from the navigation stack.
        self.onboardingViewController?.navigationController?.popViewController(animated: true)

        // Notify the delegate (AppCoordinator) to navigate the user to the sign-in flow.
        self.delegate?.navigateUserToSignIn()

        // Call the finishAction closure to inform the parent coordinator that this flow has finished.
        self.finishAction(self)
    }
}
