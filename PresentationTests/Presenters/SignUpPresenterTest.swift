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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "O campo Nome é obrigatorio"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "O campo E-mail é obrigatorio"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "O campo Senha é obrigatorio"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "O campo Confirmacao da Senha é obrigatorio"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Falha ao confirmar senha"))
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
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(message: "Email invalido"))
            exp.fulfill()
        }
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [exp], timeout: 1)
    }
    
    func test_signUp_should_call_addAccount_with_correct_values() {
        //validando o add account
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAccount: addAccountSpy)
        sut.signUp(viewModel:  makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
        }
    
    func test_signUp_should_show_error_message_if_addAccount_fails() {
        let alertViewSpy = AlertViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let signUpViewModel = makeSignUpViewModel(confirmPassword: nil)
        
        //como é assincrono, vamos utilizar o expectation
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeInvalidAlertViewModel(message: "O campo Confirmacao da Senha é obrigatorio"))
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
        

        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeSuccessAlertViewModel(message: "Conta criada com sucesso."))
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
            //Dois formato para devolver o SUT como uma Tupla
            //    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy, emailValidator: EmailValidatorSpy) {
            //        let alertViewSpy = AlertViewSpy()
            //        let emailValidator = EmailValidatorSpy()
            //        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidator)//injetando o protocol para comunicar com a controller
            //        return (sut, alertViewSpy, emailValidator)
            //    }
            
    func makeSut(alertView: AlertView = AlertViewSpy(), emailValidator: EmailValidator = EmailValidatorSpy(), addAccount: AddAccountSpy = AddAccountSpy(), loadingView: LoadingViewSpy = LoadingViewSpy(), file: StaticString = #file, line: UInt = #line) -> SignUpPresenter {
        let sut = SignUpPresenter(alertView: alertView, emailValidator: emailValidator, addAccount: addAccount, loadingView: loadingView)//injetando o protocol para comunicar com a controller
        checkMemoryLeak(for: sut, file: file, line: line)
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
     
    func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
            return AlertViewModel(title: "Sucesso", message: message)
      }
            
    //Dessa forma que o meu presenter se comunica com a controller
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        //criando um observe para pode enviar mensagem dentro da resposta do callback
        var emit: ((AlertViewModel) -> Void)?
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
        
        func showMessagem(viewModel: AlertViewModel) {
            self.emit?(viewModel)
            
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
        var completion: ((Result<AccountModel, DomainError>) -> Void)?
        
        func addAccount(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completion
        }
        
        //criando um help para executar o completion
        func completeWithError(_ error: DomainError) {
            completion?(.failure(error))
        }
        
        func completeWithAccount(_ account: AccountModel) {
            completion?(.success(account))
        }
    }
        
        class LoadingViewSpy: LoadingView {
            
            var emit: ((LoadingViewModel) -> Void)?
            
            func observe(completion: @escaping (LoadingViewModel) -> Void) {
                self.emit = completion
            }
            
            func display(viewModel: LoadingViewModel){
                self.emit?(viewModel)
        }
    }
}
        
