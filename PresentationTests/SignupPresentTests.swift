//
//  SignupPresentTests.swift
//  SignupPresentTests
//
//  Created by Pedro Silva Dos Santos on 25/08/21.
//

import XCTest

class SignupPresenter {
    private var alertView: AlertViewProtocol
    
    init(alertView: AlertViewProtocol) {
        self.alertView = alertView
    }
    
    func signup(viewModel: SignupViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMenssage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        }
    }
    
    private func validate(viewModel: SignupViewModel) -> String? {
        if (viewModel.name == nil || viewModel.name!.isEmpty) {
            return "o campo nome é obrigatorio"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "o campo e-mail é obrigatorio"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "o campo senha é obrigatorio"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "o campo senha é obrigatorio"
    }
        return nil
    }
}

protocol AlertViewProtocol {
    func showMenssage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}

struct SignupViewModel {
 var name: String?
   var email: String?
   var password: String?
   var passwordConfirmation: String?
    
}


class SignupPresentTests: XCTestCase {
    func test_signup_should_show_error_message_if_name_is_not_provided() {
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = makeSignupviewModel()
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "falha na validacao", message: "o campo nome é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_email_is_not_provided() {
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = makeSignupviewModel()
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "falha na validacao", message: "o campo e-mail é obrigatorio"))
    }
    
    func test_signup_should_show_error_message_if_senha_is_not_provided() {
        let (sut,alertViewSpy) = makeSut()
        let signupViewModel = makeSignupviewModel()
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "falha na validacao", message: "o campo senha é obrigatorio"))
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
    
    
    func makeSignupviewModel() -> SignupViewModel {
        return SignupViewModel(email: "any_email", password: "any_senha", passwordConfirmation: "any_senha")
    }
}
