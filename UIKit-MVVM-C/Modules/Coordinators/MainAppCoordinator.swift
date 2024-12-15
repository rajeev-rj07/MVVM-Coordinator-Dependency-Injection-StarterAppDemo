//
//  HomeCoordinator.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 14/12/24.
//

import UIKit
import Swinject

// MainAppCoordinator is responsible for managing the flow of the main app.
// It coordinates navigation to the main app's features, such as the Home screen.
final class MainAppCoordinator: ViewControllerCoordinator {

    // Dependency injection container for resolving services and dependencies.
    var container: Container

    // Navigation controller to manage view controller transitions within the app.
    var navigationController: UINavigationController

    // A weak reference to the HomeViewController to prevent strong reference cycles and memory leaks.
    weak var homeViewController: HomeViewController?

    // An array of child coordinators to handle multiple flows simultaneously within the app.
    var childCoordinators = [ViewControllerCoordinator]()

    // A closure that is executed when this coordinator finishes its job.
    // Typically used to notify a parent coordinator that the current flow is complete.
    var finishAction: (any ViewControllerCoordinator) -> Void

    // Destructor for MainAppCoordinator, called when it is deallocated.
    // Useful for debugging and tracking memory management.
    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    // Initializer for MainAppCoordinator.
    // - Parameters:
    //   - container: The Swinject container used for dependency injection.
    //   - navigationController: The UINavigationController that manages view navigation.
    //   - finishAction: A closure called when the coordinator finishes its flow.
    init(container: Swinject.Container, navigationController: UINavigationController, finishAction: @escaping (any ViewControllerCoordinator) -> Void) {
        self.container = container
        self.navigationController = navigationController
        self.finishAction = finishAction
    }

    // Starts the MainAppCoordinator by presenting the HomeViewController.
    func start() {
        // Instantiate the HomeViewController.
        let homeViewController = HomeViewController.instantiate()
        homeViewController.delegate = self // Set the coordinator as the delegate to handle actions from the view.
        homeViewController.viewModel = container.resolve(HomeViewModel.self)
        // If the navigation controller already has view controllers, replace the first one with the HomeViewController.
        // Otherwise, simply push the HomeViewController.
        if navigationController.viewControllers.count > 0 {
            navigationController.pushViewController(homeViewController, animated: true)
            var viewControllers = navigationController.viewControllers
            viewControllers.remove(at: 0) // Remove the root view controller from the stack.
            navigationController.viewControllers = viewControllers
        } else {
            navigationController.pushViewController(homeViewController, animated: true)
        }
    }
}

// MARK: - HomeViewControllerDelegate
// Extension to conform to the HomeViewControllerDelegate protocol, enabling communication from HomeViewController.
extension MainAppCoordinator: HomeViewControllerDelegate {

}
