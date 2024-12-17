//
//  SignInViewModelTests.swift
//  UIKit-MVVM-CTests
//
//  Created by apple on 15/12/24.
//

import Foundation
import XCTest
import Combine
@testable import UIKit_MVVM_C

final class SignInViewModelTests: XCTestCase {

    private var viewModel: SignInViewModel!
    private var mockSessionManager: MockSessionManager!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockSessionManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testButtonIsDisabledWhenEmailAndPasswordAreEmpty() throws {
        // Arrange

        mockSessionManager = MockSessionManager(testUser: createTestUser(), shouldSignInSuccess: true)
        viewModel = SignInViewModel(sessionManager: mockSessionManager)

        // Act
        viewModel.email = ""
        viewModel.password = ""

        // Assert
        XCTAssertFalse(viewModel.isButtonEnabled)
    }

    func testButtonIsDisabledWhenEmailIsInvalid() throws {
        // Arrange
        mockSessionManager = MockSessionManager(testUser: createTestUser(), shouldSignInSuccess: true)
        viewModel = SignInViewModel(sessionManager: mockSessionManager)

        // Act
        viewModel.email = "invalid-email"
        viewModel.password = "password123"

        // Assert
        XCTAssertFalse(viewModel.isButtonEnabled)
    }

    func testButtonIsEnabledWithValidEmailAndPassword() throws {
        // Arrange
        mockSessionManager = MockSessionManager(testUser: createTestUser(), shouldSignInSuccess: true)
        viewModel = SignInViewModel(sessionManager: mockSessionManager)

        // Act
        viewModel.email = "valid.email@example.com"
        viewModel.password = "password123"

        // Assert
        XCTAssertTrue(viewModel.isButtonEnabled)
    }

    func testSignInSuccess() throws {
        // Arrange
        mockSessionManager = MockSessionManager(testUser: createTestUser(), shouldSignInSuccess: true)
        viewModel = SignInViewModel(sessionManager: mockSessionManager)
        let expectation = XCTestExpectation(description: "Sign in successful")

        // Act
        viewModel.email = "valid.email@example.com"
        viewModel.password = "password123"

        viewModel.successPublisher
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.peformSignIn()

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(mockSessionManager.currentUser)
        XCTAssertTrue(mockSessionManager.isSignedIn)
    }

    func testSignInFailureWithInvalidCredentials() throws {
        // Arrange
        mockSessionManager = MockSessionManager(testUser: createTestUser(), shouldSignInSuccess: false)
        viewModel = SignInViewModel(sessionManager: mockSessionManager)
        let expectation = XCTestExpectation(description: "Sign in failed")
        var receivedError: Error?

        // Act
        viewModel.email = "valid.email@example.com"
        viewModel.password = "wrongpassword"

        viewModel.errorPublisher
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.peformSignIn()

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(mockSessionManager.currentUser)
        XCTAssertFalse(mockSessionManager.isSignedIn)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is MockSessionManager.SelfError)
    }

    func testSignOut() throws {
        // Arrange
        mockSessionManager = MockSessionManager(testUser: createTestUser(), shouldSignInSuccess: true)
        viewModel = SignInViewModel(sessionManager: mockSessionManager)
        let signInExpectation = XCTestExpectation(description: "User signed in")

        // Act
        viewModel.email = "valid.email@example.com"
        viewModel.password = "password123"

        viewModel.successPublisher
            .sink {
                signInExpectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.peformSignIn()

        wait(for: [signInExpectation], timeout: 1.0)

        mockSessionManager.signOut()

        // Assert
        XCTAssertNil(mockSessionManager.currentUser)
        XCTAssertFalse(mockSessionManager.isSignedIn)
    }

    // Helper method to create a test user
    private func createTestUser() -> User {
        return User(id: "772682251", firstName: "Rajeev", lastName: "Kulariya", email: "dev.rajeev@gmail.com")
    }
}
