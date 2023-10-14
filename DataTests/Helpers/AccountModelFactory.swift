
import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "01", name: "any_name", email: "any_email@mail.com", password: "any_password")
}

//Design Patterns - Factory
func makeAddAccountModel() -> AddAccountModel {
    return AddAccountModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
}
