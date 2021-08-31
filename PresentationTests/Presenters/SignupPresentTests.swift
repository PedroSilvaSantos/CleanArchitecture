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
        let (sut,alertViewSpy,_) = makeSut()
        let signupViewModel = SignupViewModel(email: "any_email", password: "any_password", passwordConfirmation: "any_password")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo NOME é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        let (sut,alertViewSpy,_) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", password: "any_password", passwordConfirmation: "any_password")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo E-MAIL é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_senha_is_not_provided() {
        let (sut,alertViewSpy,_) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_email", passwordConfirmation: "any_password")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo SENHA é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_valid_senha_is_not_provided() {
        let (sut,alertViewSpy,_) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_email", passwordConfirmation: "wrong_password")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo SENHA é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_password_confirmation_not_math() {
        let (sut,alertViewSpy,_) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_senha")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "Falha na validação da senha"))
    }
    
    func test_signup_should_call_emailValidator_with_correct_email() {
        let (sut, _, emailvalidatorSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "valid_any_email", password: "any_password", passwordConfirmation: "any_senha")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(emailvalidatorSpy.email, signupViewModel.email)
    }
}
    


extension SignupPresentTests {
    
    func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy, emailValidatorSpy: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = SignupPresenter(alertView: alertViewSpy, emailValidatorSpy: emailValidatorSpy)
        return (sut , alertViewSpy, emailValidatorSpy)
    }
    
    class EmailValidatorSpy: EmailValidator {
        var email: String?
        var isvalid = true
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isvalid
        }
    }
    
    class AlertViewSpy: AlertViewProtocol {
        var viewModel: AlertViewModel?

        func showMenssage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
