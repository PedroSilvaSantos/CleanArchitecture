import Foundation
import Domain

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
