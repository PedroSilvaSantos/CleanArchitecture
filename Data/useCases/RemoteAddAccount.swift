//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Pedro Silva Dos Santos on 09/08/21.
//

import Domain
import Foundation

public final class RemoteAddAccount {
    
    private var url: URL
    var httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (DomainErros) -> Void) {
        httpClient.post(to: url, with: addAccountModel.toData()) { error in
            completion(.unexpected)
        }
    }
}
