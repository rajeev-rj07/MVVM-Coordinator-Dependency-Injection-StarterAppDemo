//
//  ForgotPasswordViewController.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit

protocol ForgotPasswordViewControllerDelegate: AnyObject {
    func dismiss()
}

final class ForgotPasswordViewController: UIViewController {

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    weak var delegate: ForgotPasswordViewControllerDelegate?

    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setRandomGradientBackground()
        title = "Forgot Password"

        setupViews()
        setupConstraints()
        setupActions()
    }

    private func setupViews() {
        view.addSubview(emailTextField)
        view.addSubview(submitButton)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.leftBarButtonItem = closeButton
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),

            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            submitButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupActions() {
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }

    @objc private func submitButtonTapped() {
        self.delegate?.dismiss()
    }

    @objc private func closeButtonTapped() {
        self.delegate?.dismiss()
    }
}

extension ForgotPasswordViewController {
    static func instantiate() -> ForgotPasswordViewController {
        let viewController = ForgotPasswordViewController()
        return viewController
    }
}
