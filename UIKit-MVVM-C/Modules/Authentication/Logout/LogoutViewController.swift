//
//  LogoutViewController.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit

class LogoutViewController: UIViewController {

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setRandomGradientBackground()
        title = "Logout"

        setupViews()
        setupConstraints()
        setupActions()
    }

    private func setupViews() {
        view.addSubview(logoutButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 150),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }

    @objc private func logoutButtonTapped() {
        print("User logged out")
    }
}

