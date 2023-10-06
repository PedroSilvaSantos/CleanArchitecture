import Foundation
import Domain


//final para ninguem herdar dela
final public class RemoteAddAccount {
    //Quando o valor é de responsabilidade da classe, injetamos o valor nela
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    public init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    public func add(addAccountModel: AddAccountModel) {
        httpPostClient.post(to: url, with: addAccountModel.modelToData())
    }
}
