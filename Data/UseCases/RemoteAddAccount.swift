import Foundation
import Domain


//final para ninguem herdar dela
final public class RemoteAddAccount: AddAccount {

    //Quando o valor é de responsabilidade da classe, injetamos o valor nela
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    public init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel,DomainError>) -> Void) {
        httpPostClient.post(to: url, with: addAccountModel.modelToData()) { result in
            //O post retornando error, o callback do metodo add será disparado
            switch result {
            case .success(let data):
                if let model: AccountModel = data.toModel() {
                    completion(.success(model))
                }
               
            case .failure(_): completion(.failure(.unexpected))
            }
        }
    }
}
