//
//  HomeViewController.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 14/12/24.
//

import UIKit
import Swinject
import Combine
import Security

protocol HomeViewControllerDelegate: AnyObject {
    
}

final class HomeViewController: BaseViewController {

    // Labels for user information
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "ID: "
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name:"
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name:"
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // Logout button
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: HomeViewControllerDelegate?
    var viewModel: HomeViewModel! {
        didSet {
            print("\(HomeViewModel.self) injected via property injection")
        }
    }

    deinit {
        print("db - Deinit \(String(describing: self))")
        cancellables.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Set the background color of the view

        // Create a vertical stack view to hold the labels
        let stackView = UIStackView(arrangedSubviews: [idLabel, firstNameLabel, lastNameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10

        // Add the stack view and logout button to the view
        view.addSubview(stackView)
        view.addSubview(logoutButton)

        // Disable auto-resizing masks and use Auto Layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        // Set up Auto Layout constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50), // Push it slightly up
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Set up Auto Layout constraints for the logout button
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 150),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.sessionManager.currentUserPublisher.sink { [weak self] user in
            guard let self, let user else {return}
            self.idLabel.text = "Id: \(user.id)"
            self.firstNameLabel.text = "First Name: \(user.firstName)"
            self.lastNameLabel.text = "Last Name: \(user.lastName)"
            self.emailLabel.text = "Email: \(user.email)"
        }.store(in: &cancellables)
    }

    // Action when logout button is tapped
    @objc func logoutButtonTapped() {
        print("Logout button tapped")
        viewModel.logout()
    }
}
extension HomeViewController {
    class func instantiate() -> HomeViewController {
        let viewController = HomeViewController()
        return viewController
    }
}
