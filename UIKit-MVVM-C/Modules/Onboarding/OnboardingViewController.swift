//
//  OnboardingViewController.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 13/12/24.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func finishedOnboarding()
}

final class OnboardingViewController: UIViewController {

    // MARK: - Properties
    private lazy var onboardingTopLabel: UILabel = {
        let label = UILabel()
        label.text = "Onboarding"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var onboardingLabel: UILabel = {
        let label = UILabel()
        label.text = "MVVM-Coordinator-Dependency-Injection-StarterAppDemo"
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0 // Allows multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    deinit {
        print("db - Deinit \(String(describing: self))")
    }

    weak var delegate: OnboardingViewControllerDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setRandomGradientBackground()

        // Add the label and button to the view
        view.addSubview(onboardingTopLabel)
        view.addSubview(onboardingLabel)
        view.addSubview(skipButton)

        setupConstraints()
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }

    // MARK: - Constraints Setup
    private func setupConstraints() {
        // Onboarding Label Constraints
        NSLayoutConstraint.activate([
            onboardingTopLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            onboardingTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            onboardingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            onboardingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            onboardingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])

        // Skip Button Constraints
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    // MARK: - Actions
    @objc private func skipButtonTapped() {
        delegate?.finishedOnboarding()
    }
}

extension OnboardingViewController {
    static func instantiate() -> OnboardingViewController {
        let viewController = OnboardingViewController()
        return viewController
    }
}
