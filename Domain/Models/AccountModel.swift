//
//  AccountModel.swift
//  Domain
//
//  Created by Pedro Silva Dos Santos on 04/08/21.
//

import Foundation

public struct Accountmodel: Model {
    public var accessToken: String
    public var name: String

    
    public init (accessToken: String, name: String) {
        self.accessToken = accessToken
        self.name = name
    }
}
