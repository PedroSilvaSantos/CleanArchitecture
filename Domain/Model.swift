//
//  Model.swift
//  Domain
//
//  Created by Pedro Silva Dos Santos on 09/08/21.
//

import Foundation

public protocol Model: Encodable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
