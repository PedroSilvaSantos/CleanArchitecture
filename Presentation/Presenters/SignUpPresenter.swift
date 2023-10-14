import Foundation

public final class SignUpPresenter {
    
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    
    public init(alertView: AlertView, emailValidator: EmailValidator) {
        self.alertView = alertView
        self.emailValidator = emailValidator
    }

    public func signUp(viewModel: SignUpViewModel) {
        //Se o validade retornar um texto é porque existe um error
        if let message = validation(viewModel: viewModel) {
            alertView.showMessagem(viewModel: AlertViewModel(title: "Falha na validacao", message: message))
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
        }
        _ = emailValidator.isValid(email: viewModel.email!)
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

