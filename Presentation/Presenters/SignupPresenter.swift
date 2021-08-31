//
//  SignupPresenter.swift
//  Presentation
//
//  Created by Pedro Silva Dos Santos on 31/08/21.
//

import Foundation

public final class SignupPresenter {
    private var alertView: AlertViewProtocol
    private var emailValidatorSpy: EmailValidator
    
    public init(alertView: AlertViewProtocol, emailValidatorSpy: EmailValidator) {
        self.alertView = alertView
        self.emailValidatorSpy = emailValidatorSpy
    }
    
    public func signup(viewModel: SignupViewModel) {
        if let message = validate(viewModel: viewModel) {
            alertView.showMenssage(viewModel: AlertViewModel(title: "Falha na validação", message: message))
        }
    }
    
    private func validate(viewModel: SignupViewModel) -> String? {
        if (viewModel.name == nil || viewModel.name!.isEmpty) {
            return "o campo NOME é obrigatorio"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "o campo E-MAIL é obrigatorio"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "o campo SENHA é obrigatorio"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "o campo SENHA é obrigatorio"
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "Falha na validação da senha"
        } else if !emailValidatorSpy.isValid(email: viewModel.email!) { //senao for valido
            return "Email invalido"
        }
        return nil
    }
}

public struct SignupViewModel {
   public var name: String?
   public var email: String?
   public var password: String?
   public var passwordConfirmation: String?
    
    public init (name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}

