//
//  AccountModel.swift
//  Domain
//
//  Created by Pedro Silva Dos Santos on 04/08/21.
//

import Foundation

public struct Accountmodel: Model {
    var id: String
    var name: String
    var email: String
    var password: String
    
    public init (id: String,name: String,email: String,password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
