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
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(message: "O campo Nome é obrigatorio"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_shold_show_error_message_is_email_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(email: nil)

        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(message: "O campo E-mail é obrigatorio"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_shold_show_error_message_is_password_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(password: nil)
        
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(message: "O campo Senha é obrigatorio"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_shold_show_error_message_is_password_confirmation_is_not_provided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(confirmPassword: nil)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(message: "O campo Confirmacao da Senha é obrigatorio"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_shold_show_error_message_is_password_confirmation_is_not_math() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(confirmPassword: "fail_password")
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeRequiredAlertViewModel(message: "Falha ao confirmar senha"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
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
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(message: "Email invalido"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_call_addAccount_with_correct_values() {
        //validando o add account
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
        }
    
    func test_signUp_should_show_error_message_if_addAccount_fails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(confirmPassword: nil)
        
        //como é assincrono, vamos utilizar o expectation
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeInvalidAlertViewModel(message: "O campo Confirmacao da Senha é obrigatorio"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
      }
    
    
    func test_signUp_should_show_success_message_if_addAccount_succeeds() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        //como é assincrono, vamos utilizar o expectation
        let exp = expectation(description: "waiting")
        let sut = makeSut(alertView: alertViewSpy, addAccount: addAccountSpy)
        let signUpViewModel = makeSignUpViewModel()
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, makeSuccessAlertViewModel(message: "Conta criada com sucesso."))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        //Ocorrendo tudo certo, completar esse completion com isso
        addAccountSpy.completeWithAccount(makeAccountModel())
        wait(for: [exp], timeout: 1)
      }
    
    func test_signUp_should_show_loading_before_call_after_addAccount() {
        let loadingViewSpy = LoadingViewSpy()
        //####################################################################################"
        //Injetando o AddAccount
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy, loadingView: loadingViewSpy)
        //####################################################################################"
        
        let exp = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel.init(isLoading: true))
        }
        exp.fulfill()
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [exp], timeout: 1)
        
        //###########Validando o loading view com status false#################################"
        let exp2 = expectation(description: "waiting")
        loadingViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, LoadingViewModel.init(isLoading: false))
        }
        exp2.fulfill()
        
        //depois que executei tudo, vou executar esse aqui
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [exp2], timeout: 1)
      }
    }
                   
    extension SignUpPresenterTest {
        
        func makeSut(alertView: AlertView = AlertViewSpy(), emailValidator: EmailValidator = EmailValidatorSpy(), addAccount: AddAccountSpy = AddAccountSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(), file: StaticString = #file, line: UInt = #line) -> SignUpPresenter {
            let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount, loadingView: loadingView)//injetando o protocol para comunicar com a controller
            checkMemoryLeak(for: sut, file: file, line: line)
            return (sut)
        }
            //Dois formato para devolver o SUT como uma Tupla
            //    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy, emailValidator: EmailValidatorSpy) {
            //        let alertViewSpy = AlertViewSpy()
            //        let emailValidator = EmailValidatorSpy()
            //        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidator)//injetando o protocol para comunicar com a controller
            //        return (sut, alertViewSpy, emailValidator)
            //    }
        
}
        
