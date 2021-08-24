//
//  Helpers.swift
//  Data
//
//  Created by Pedro Silva Dos Santos on 10/08/21.
//

import Foundation

public extension Data {
    //serializando um data para um model
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
    func toJson() -> [String : Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed) as? [String : Any]
    }
}
