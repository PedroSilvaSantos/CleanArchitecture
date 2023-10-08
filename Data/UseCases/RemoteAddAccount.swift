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
        httpPostClient.post(to: url, with: addAccountModel.modelToData()) { [weak self] result in
            //validando se a minha classe foi desalocada da memoria, se sim, deverá sair sem executar o callback
            guard self != nil else { return }
            switch result {
                case .success(let data):
                    if let model: AccountModel = data?.dataToModel() { //transformando um Data em um Model
                        completion(.success(model))
                    } else {
                        completion(.failure(.unexpected))
                    }
                case .failure(_): completion(.failure(.unexpected))
            }
        }
    }
}
