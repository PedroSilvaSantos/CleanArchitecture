import Foundation
import Domain

public final class SignUpPresenter {
    
    private let alertView: AlertView //protocolo que o controller precisará assinar
    private let emailValidator: EmailValidator //protocolo que o controller precisará assinar
    private let addAccount: AddAccount
    
    public init(alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount) {
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAccount = addAccount
    }

    public func signUp(viewModel: SignUpViewModel) {
        //Se o validade retornar um texto é porque existe um error
        if let message = validation(viewModel: viewModel) {
            alertView.showMessagem(viewModel: AlertViewModel(title: "Falha na validacao", message: message))
        } else {
            //transfomando o SignUpViewModel em um AddAccountModel
            let addAccountModel = AddAccountModel(name: viewModel.name!, email: viewModel.email!, password: viewModel.password!, passwordConfirmation: viewModel.confirmPassword!)
            addAccount.addAccount(addAccountModel: addAccountModel) { result in
                switch result {
                case .success(_):
                    print("Sucesso")
                case .failure(_):
                    print("Error")
                }
            }
        }
    }
    
    //tratando as messagens de erros caso falhe
    private func validation(viewModel: SignUpViewModel) -> String? {
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "O campo Nome é obrigatorio"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "O campo E-mail é obrigatorio"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "O campo Senha é obrigatorio"
        } else if viewModel.confirmPassword == nil || viewModel.confirmPassword!.isEmpty {
            return "O campo Confirmacao da Senha é obrigatorio"
        } else if viewModel.password != viewModel.confirmPassword  {
            return "Falha ao confirmar senha"
        } else if !emailValidator.isValid(email: viewModel.email!) { //se o email nao for valido devolve essa msg
            return "Email invalido"
        }
        return nil
    }
}


public struct SignUpViewModel {
      public var name: String?
      public var email: String?
      public var password: String?
      public var confirmPassword: String?
    
    public init(name: String?, email: String?, password: String?, confirmPassword: String?) {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}

