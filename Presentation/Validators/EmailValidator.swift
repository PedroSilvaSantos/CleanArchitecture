//
//  EmailValidator.swift
//  Presentation
//
//  Created by Pedro Silva Dos Santos on 31/08/21.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
