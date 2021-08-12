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
        
        //corrigindo o problema de memory leak inserindo essa propriedade no metodo[weak self]
        //a partir desse momento a referencia dessa classe RemoteAddAccount é fraca, ela morrendo poderá liberar memoria da variavel
        httpClient.post(to: url, with: addAccountModel.toData()) { [weak self] result in
            
            //MARK: teste criando um error de memory leak
            var memory = self?.httpClient
            
            //MARK: resolvendo problema de classe desalocada da memoria
            //caso o self seja == nil, o metodo do completion não deverá ser acionado, saindo metodo nesse momento
            guard self != nil else { return }
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
