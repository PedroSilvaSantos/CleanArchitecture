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
    
    func signup(viewModel: SignupViewModel ) {
        if (viewModel.name == nil || viewModel.name!.isEmpty) {
            alertView.showMenssage(viewModel: AlertViewModel(title: "falha na validacao", message: "o campo nome é obrigatorio"))
        }
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
    func test_signup() {
        let alertViewSpy = AlertViewSpy()
        let sut = SignupPresenter(alertView: alertViewSpy)
        let signupViewModel = makeSignupviewModel()
        sut.signup(viewModel: signupViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "falha na validacao", message: "o campo nome é obrigatorio"))
    }
}
    


extension SignupPresentTests {
    class AlertViewSpy: AlertViewProtocol {
        
        var viewModel: AlertViewModel?

        func showMenssage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
    
    
    func makeSignupviewModel() -> SignupViewModel {
        return SignupViewModel(email: "any_email", password: "any_senha", passwordConfirmation: "any_senha")
    }
}
