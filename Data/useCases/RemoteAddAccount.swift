//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Pedro Silva Dos Santos on 09/08/21.
//

import Domain
import Foundation

public final class RemoteAddAccount: AddAccount {
    
    private var url: URL
    var httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<Accountmodel, DomainErros>) -> Void) {
        httpClient.post(to: url, with: addAccountModel.toData()) { result in
            switch result {
            case .success(let data):
                if let model: Accountmodel = data.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
                case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
