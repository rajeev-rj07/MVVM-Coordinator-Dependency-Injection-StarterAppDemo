//
//  SignInViewModel.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 15/12/24.
//

import Foundation
import Combine

final class SignInViewModel: ViewModelType {
    @Published var isButtonEnabled: Bool = false
    @Published var email: String?
    @Published var password: String?

    let errorPublisher = PassthroughSubject<Error, Never>()
    let successPublisher = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    private let sessionManager: SessionManaging

    deinit {
        print("db - Deinit \(String(describing: self))")
        cancellables.removeAll()
    }

    init(sessionManager: SessionManaging) {
        self.sessionManager = sessionManager
        bind()
    }

    func bind() {
        $email.combineLatest($password)
            .map({ [weak self] email, password in
                guard let email, let password, let self, email.isEmpty == false, password.isEmpty == false else { return false }
                let isValid = self.isValidEmail(email: email) && password.count > 3
                return isValid
            })
            .assign(to: &$isButtonEnabled)
    }

    func peformSignIn() {
        guard let email, let password else { return }

        sessionManager.signIn(email: email, password: password)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorPublisher.send(error)
                }
            } receiveValue: { [weak self] _ in
                self?.successPublisher.send()
            }
            .store(in: &cancellables)
    }
}

extension SignInViewModel {
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
