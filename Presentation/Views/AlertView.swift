import Foundation


//criando um protocol como dependencia, pois é o meio de comunicacao com a contgroller
public protocol AlertView {
    func showMessagem(viewModel: AlertViewModel)
}
 

public struct AlertViewModel: Equatable {
    public var title: String
    public var message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
