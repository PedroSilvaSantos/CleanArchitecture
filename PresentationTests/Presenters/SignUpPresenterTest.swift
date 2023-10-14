import XCTest
import Presentation
import Domain

class SignUpPresenterTest: XCTestCase {
    //vai ter a tela com o formulario
    //seus comportamentos, teremos que validar o formulario e garantir que as senha sao iguais e validar o email se tudo eseicver certo chmar o use case para criar conta
    //load view
    //mostrar error ou sucesso
    func test_signUp_shold_show_error_message_is_name_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(name: nil)
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "O campo Nome é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_email_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(email: nil)
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "O campo E-mail é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(password: nil)
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "O campo Senha é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(confirmPassword: nil)
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "O campo Confirmacao da Senha é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_confirmation_is_not_math() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(confirmPassword: "fail_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Falha ao confirmar senha"))
    }
    
    func test_signUp_shold_call_emailValidator_with_correct_email() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    func test_signUp_should_show_error_message_if_invalid_email_is_provided() {
        let emailValidatorSpy = EmailValidatorSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeInvalidAlertViewModel(message: "Email invalido"))
    }
    
    func test_signUp_should_call_addAccount_with_correct_values() {
        //validando o add account
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
        }
    }
                   
    extension SignUpPresenterTest {
            
            //Dois formato para devolver o SUT como uma Tupla
            //    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy, emailValidator: EmailValidatorSpy) {
            //        let alertViewSpy = AlertViewSpy()
            //        let emailValidator = EmailValidatorSpy()
            //        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidator)//injetando o protocol para comunicar com a controller
            //        return (sut, alertViewSpy, emailValidator)
            //    }
            
    func makeSut(alertView: AlertView = AlertViewSpy(), emailValidator: EmailValidator = EmailValidatorSpy(), addAccount: AddAccountSpy = AddAccountSpy()) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount)//injetando o protocol para comunicar com a controller
        return (sut)
    }
            
    func makeSignUpViewModel(name: String? = "any_name", email: String? = "any_email@mail.com", password: String? = "any_password", confirmPassword: String? = "any_password") -> SignUpViewModel {
        return SignUpViewModel(name: name, email: email, password: password, confirmPassword: confirmPassword)
            }
            
    func makeRequiredAlertViewModel(title: String = "Falha na validacao", message: String) -> AlertViewModel {
        return AlertViewModel(title: title, message: message)
            }
            
    func makeInvalidAlertViewModel(title: String = "Falha na validacao", message: String) -> AlertViewModel {
                return AlertViewModel(title: title, message: message)
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
                
        func simulateInvalidEmail() {
            isValid = false
        }
    }
            
    class AddAccountSpy: AddAccount {
                
        var addAccountModel: AddAccountModel?
                
        func addAccount(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
                    self.addAccountModel = addAccountModel
                }
            }
        }
