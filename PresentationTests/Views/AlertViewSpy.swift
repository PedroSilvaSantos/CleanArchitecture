
import Foundation
import Presentation

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
