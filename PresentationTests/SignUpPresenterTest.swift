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
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)//injetando o protocol para comunicar com a controller
        let signUpViewModel = SignUpViewModel(email: "any_email@mail.com", password: "any_password", confirmPassword: "any_password")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Falha na validacao", message: "O campo Nome é obrigatorio"))
        
    }
    
    
}

extension SignUpPresenterTest {
    
    //Dessa forma que o meu presenter se comunica com a controller
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessagem(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
