//
//  Model.swift
//  Domain
//
//  Created by Virtual Machine on 05/10/23.
//

import Foundation

public protocol Model: Encodable {}


public extension Model {
    func modelToData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
