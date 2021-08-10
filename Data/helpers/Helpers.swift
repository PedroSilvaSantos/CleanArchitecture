//
//  Helpers.swift
//  Data
//
//  Created by Pedro Silva Dos Santos on 10/08/21.
//

import Foundation

public extension Data {
    //transformando um data para model
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
