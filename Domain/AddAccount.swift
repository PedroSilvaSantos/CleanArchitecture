//
//  AddAccount.swift
//  Domain
//
//  Created by Pedro Silva Dos Santos on 04/08/21.
//

import Foundation

public protocol AddAccount {
    //operacao assincrono, como deveremos esperar o resultado da api, vamos criar um callback
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result <Accountmodel, Error>) -> Void)
    //receber alguns dados do cadastro, atraves de um model
}


public struct AddAccountModel: Model {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
    
    //como deixei o metodo da struct publico, eu perdi o construtor padrao, porque o normal é ele ser internal
    public init(name: String, email: String, password: String, passwordConfirmation: String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
