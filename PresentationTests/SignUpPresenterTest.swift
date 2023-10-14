import XCTest

class SignUpPresenter {
    
    private let alertView: AlertView
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        //será chamado quando a propriedade name gerar error
        if viewModel.name == nil || viewModel.name!.isEmpty {
            alertView.showMessagem(viewModel: AlertViewModel(title: "Falha na validacao", message: "O campo Nome é obrigatorio"))
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            alertView.showMessagem(viewModel: AlertViewModel(title: "Falha na validacao", message: "O campo E-mail é obrigatorio"))
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            alertView.showMessagem(viewModel: AlertViewModel(title: "Falha na validacao", message: "O campo Senha é obrigatorio"))
        } else if viewModel.confirmPassword == nil || viewModel.confirmPassword!.isEmpty {
            alertView.showMessagem(viewModel: AlertViewModel(title: "Falha na validacao", message: "O campo Confirmacao da Senha é obrigatorio"))
        }
    }
}

//criando um protocol como dependencia, pois é o meio de comunicacao com a contgroller
protocol AlertView {
    func showMessagem(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}
 
struct SignUpViewModel {
      var name: String?
      var email: String?
      var password: String?
      var confirmPassword: String?
}

final class SignUpPresenterTest: XCTestCase {


    //vai ter a tela com o formulario
    //seus comportamentos, teremos que validar o formulario e garantir que as senha sao iguais e validar o email se tudo eseicver certo chmar o use case para criar conta
    //load view
    //mostrar error ou sucesso
    func test_signUp_shold_show_error_message_is_name_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(email: "any_email@mail.com", password: "any_password", confirmPassword: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Nome é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_email_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", password: "any_password", confirmPassword: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo E-mail é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_is_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Senha é obrigatorio"))
    }
    
    func test_signUp_shold_show_error_message_is_password_confirmation_is_not_provider() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "any_name", email: "any_email@mail.com", password: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Confirmacao da Senha é obrigatorio"))
    }
}

extension SignUpPresenterTest {
    
    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)//injetando o protocol para comunicar com a controller
        return (sut, alertViewSpy)
    }
    
    //Dessa forma que o meu presenter se comunica com a controller
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessagem(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
