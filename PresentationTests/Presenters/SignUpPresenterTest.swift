import XCTest
import Presentation

 class SignUpPresenterTest: XCTestCase {
    //vai ter a tela com o formulario
    //seus comportamentos, teremos que validar o formulario e garantir que as senha sao iguais e validar o email se tudo eseicver certo chmar o use case para criar conta
    //load view
    //mostrar error ou sucesso
    func test_signUp_shold_show_error_message_is_name_not_provider() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "", email: "any_email@mail.com", password: "any_password", confirmPassword: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Nome é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_email_not_provider() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "", password: "any_password", confirmPassword: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo E-mail é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_is_not_provider() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "", confirmPassword: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Senha é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_confirmation_is_not_provider() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password", confirmPassword: "")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Confirmacao da Senha é obrigatorio"))
    }
     
     func test_signUp_shold_show_error_message_is_password_confirmation_is_not_math() {
         let (sut, alertViewSpy, _) = makeSut()
         let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password", confirmPassword: "fail_password")
         sut.signUp(viewModel: signUpViewModel)
         XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "Falha ao confirmar senha"))
     }
     
     func test_signUp_shold_call_emailValidator_with_correct_email() {
         let (sut, _, emailValidatorSpy) = makeSut()
         let signUpViewModel = SignUpViewModel(name: "any_name", email: "invalid_email@mail.com", password: "any_password", confirmPassword: "any_password")
         sut.signUp(viewModel: signUpViewModel)
         XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
     }
}

extension SignUpPresenterTest {
    
    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy, emailValidator: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidator = EmailValidatorSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidator)//injetando o protocol para comunicar com a controller
        return (sut, alertViewSpy, emailValidator)
    }
    
    //Dessa forma que o meu presenter se comunica com a controller
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessagem(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }

    
    class EmailValidatorSpy: EmailValidator {//protocol EmailValidator
        var isValid = true
        var email: String?
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
    }
}
