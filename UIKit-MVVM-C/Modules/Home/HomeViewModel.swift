//
//  HomeViewModel.swift
//  UIKit-MVVM-C
//
//  Created by Rajeev Kulariya on 15/12/24.
//

import Foundation
import Swinject
import Combine

final class HomeViewModel: ViewModelType {

    var sessionManager: SessionManaging

    init(sessionManager: SessionManaging) {
        self.sessionManager = sessionManager
    }

    func bind() {

    }

    func logout() {
        NotificationCenter.default.post(name: .userDidLogin, object: nil, userInfo: nil)
    }
}
