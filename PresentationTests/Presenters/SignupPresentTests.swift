//
//  SignupPresentTests.swift
//  SignupPresentTests
//
//  Created by Pedro Silva Dos Santos on 25/08/21.
//

import XCTest
import Presentation

class SignupPresentTests: XCTestCase {
    
    func test_signup_should_show_error_message_if_name_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signup(viewModel: makeSignUpViewModel(name: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(fieldName: "NOME"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signup(viewModel: makeSignUpViewModel(email: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(fieldName: "E-MAIL"))
    }
    
    func test_signup_should_show_error_message_if_senha_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signup(viewModel: makeSignUpViewModel(password: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(fieldName: "SENHA"))
    }
    
    func test_signup_should_show_error_message_if_valid_senha_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signup(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(fieldName: "SENHA"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_not_math() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.signup(viewModel: makeSignUpViewModel(passwordConfirmation: "wrong_password"))
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertCompararPassword(fieldName: "Falha ao confirmar a senha"))
    }
    
    func test_signup_should_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signup(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signup_should_show_error_message_if_invalid_email_is_provided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        emailValidatorSpy.simulateInvalidEmail()
        sut.signup(viewModel: makeSignUpViewModel())
        XCTAssertEqual(alertViewSpy.viewModel, makeAlertViewModel(fieldName: "Email invalido"))
    }
}
    


extension SignupPresentTests {
    
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), emailValidator: EmailValidatorSpy = EmailValidatorSpy()) -> SignupPresenter {
        let sut = SignupPresenter(alertView: alertView, emailValidatorSpy: emailValidator)
        return sut
    }
    
    func makeSignUpViewModel(name: String? = "any_name", email: String? = "invalid_any_email", password: String? = "any_password", passwordConfirmation: String? = "any_password") -> SignupViewModel {
        return SignupViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeAlertViewModel(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message: "o campo \(fieldName) é obrigatorio")
    }
    
    func makeAlertCompararPassword(fieldName: String) -> AlertViewModel {
        return AlertViewModel(title: "Falha na validação", message:  fieldName)
    }
    
    class EmailValidatorSpy: EmailValidator {
        var email: String?
        var isValid = true
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
        
        func simulateInvalidEmail() {
            isValid = false
        }
    }
    
    class AlertViewSpy: AlertViewProtocol {
        var viewModel: AlertViewModel?

        func showMenssage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
