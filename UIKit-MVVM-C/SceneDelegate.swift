//
//  SceneDelegate.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController, finishAction: { _ in 

        })
        appCoordinator?.start()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()


    }
}


/*

 let window = UIWindow(windowScene: windowScene)
 UINavigationBar.appearance().tintColor = .white

 UINavigationBar.appearance().barTintColor = .white

 UINavigationBar.appearance().isTranslucent = false

 let viewController = OnboardingViewController()
 viewController.title = "asa"
 viewController.view.setRandomGradientBackground()
 let navigation = UINavigationController(rootViewController: viewController)


 window.rootViewController = navigation


 self.window = window
 window.makeKeyAndVisible()
 */
