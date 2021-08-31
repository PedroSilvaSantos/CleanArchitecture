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
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(email: "any_email", password: "any_senha", passwordConfirmation: "any_senha")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo NOME é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", password: "any_senha", passwordConfirmation: "any_senha")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo E-MAIL é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_senha_is_not_provided() {
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_email", passwordConfirmation: "any_senha")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo SENHA é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_valid_senha_is_not_provided() {
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = SignupViewModel(name: "any_name", email: "any_email", passwordConfirmation: "any_senha")
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validação", message: "o campo SENHA é obrigatorio"))
    }
}
    


extension SignupPresentTests {
    class AlertViewSpy: AlertViewProtocol {
    
        var viewModel: AlertViewModel?

        func showMenssage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
        func makeSut() -> (sut: SignupPresenter, alertViewSpy: AlertViewSpy) {
            let alertViewSpy = AlertViewSpy()
            let sut = SignupPresenter(alertView: alertViewSpy)
        return (sut , alertViewSpy)
    }
}
