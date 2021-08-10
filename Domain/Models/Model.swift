//
//  Model.swift
//  Domain
//
//  Created by Pedro Silva Dos Santos on 09/08/21.
//

import Foundation

//Utilizando o Equatable para que qlq modulo que for implementado poderá ser comparado, mudando para Codable para cobrir os dois cennarios Decodable & Encodable
public protocol Model: Codable,Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
