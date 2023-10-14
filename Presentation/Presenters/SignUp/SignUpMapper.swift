import Foundation
import Domain

final class SignUpMapper {
    
    static func mapToaddAccountModel(viewModel: SignUpViewModel) -> AddAccountModel{
        return AddAccountModel(name: viewModel.name!, email: viewModel.email!, password: viewModel.password!, passwordConfirmation: viewModel.confirmPassword!)
    }
}
