//
//  SignInViewController.swift
//  MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit
import Combine
import CombineCocoa

protocol SignInViewControllerDelegate: AnyObject {
    func navigateUserToHome()
    func navigateUserToSignUp()
    func navigateUserToForgotPassword()
}

final class SignInViewController: BaseViewController {

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password", for: .normal)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    private var cancellables = Set<AnyCancellable>()
    weak var delegate: SignInViewControllerDelegate?
    var viewModel: SignInViewModel! {
        didSet {
            print("\(SignInViewModel.self) injected via property injection")
        }
    }

    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        navigationItem.hidesBackButton = true
        setupViews()
        setupConstraints()
        bind()
    }

    private func setupViews() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPasswordButton)

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),

            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signInButton.widthAnchor.constraint(equalToConstant: 150),

            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 150),

            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    func bind() {
        emailTextField.text = "dev.rajeev1996@gmail.com"
        passwordTextField.text = "123456"
        
        emailTextField.textPublisher.removeDuplicates().assign(to: &viewModel.$email)
        viewModel.$email.removeDuplicates().assign(to: \.text, on: emailTextField)
            .store(in: &cancellables)

        passwordTextField.textPublisher.removeDuplicates().assign(to: &viewModel.$password)
        viewModel.$email.removeDuplicates().assign(to: \.text, on: emailTextField)
            .store(in: &cancellables)

        viewModel.$isButtonEnabled.assign(to: \.isEnabled, on: signInButton)
            .store(in: &cancellables)

        viewModel.successPublisher.sink { [weak self] _ in
            guard let self else { return }
            self.delegate?.navigateUserToHome()
        }
        .store(in: &cancellables)
    }

    @objc private func signInButtonTapped() {
        viewModel.peformSignIn()
    }

    @objc private func signUpButtonTapped() {
        delegate?.navigateUserToSignUp()
    }

    @objc private func forgotPasswordButtonTapped() {
        delegate?.navigateUserToForgotPassword()
    }
}

extension SignInViewController {
    class func instantiate() -> SignInViewController {
        let viewController = SignInViewController()
        return viewController
    }
}
