//
//  Coordinator.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit
import Swinject

protocol Coordinator: AnyObject {
    /// Notifies the parent coordinator that the current child coordinator has completed its task.
    /// The parent can use this to remove the reference to the child coordinator.
    var finishAction: (ViewControllerCoordinator) -> Void { get }

    /// Starts the coordinator's flow, typically by setting up and displaying the initial view controller.
    func start()
}

/// A coordinator responsible for managing view controllers.
/// Each ViewControllerCoordinator should have a `rootViewController` to control its navigation stack.
/// It's important to hold a `weak` reference to any UIViewController managed by the coordinator
/// to avoid retain cycles, and `deinit` of the view controller should notify the coordinator to remove itself.
protocol ViewControllerCoordinator: Coordinator {
    /// The dependency injection container, used to resolve dependencies for the view controllers managed by this coordinator.
    var container: Container { get set }

    /// The UINavigationController responsible for pushing and managing the navigation stack of view controllers.
    var navigationController: UINavigationController { get set }
}
