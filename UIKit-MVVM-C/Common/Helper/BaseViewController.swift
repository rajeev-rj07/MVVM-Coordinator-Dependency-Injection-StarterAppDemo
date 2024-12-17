//
//  BaseViewController.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 17/12/24.
//

import Foundation
import SwiftUI

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = MeshGradientOverview().edgesIgnoringSafeArea(.all)
        // Create the UIHostingController for the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add the UIHostingController's view as a subview
        addChild(hostingController)
        
        // Set up constraints for the SwiftUI view
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        // Add constraints for positioning
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        // Notify the hosting controller that it's been added
        hostingController.didMove(toParent: self)
    }
}
