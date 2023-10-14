import Foundation
import Presentation

public func makeSignUpViewModel(name: String? = "any_name", email: String? = "any_email@mail.com", password: String? = "any_password", confirmPassword: String? = "any_password") -> SignUpViewModel {
    return SignUpViewModel(name: name, email: email, password: password, confirmPassword: confirmPassword)
    }
        
public func makeRequiredAlertViewModel(title: String = "Falha na validacao", message: String) -> AlertViewModel {
    return AlertViewModel(title: title, message: message)
    }
        
public func makeInvalidAlertViewModel(title: String = "Falha na validacao", message: String) -> AlertViewModel {
        return AlertViewModel(title: title, message: message)
    }
 
public func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
        return AlertViewModel(title: "Sucesso", message: message)
  }
