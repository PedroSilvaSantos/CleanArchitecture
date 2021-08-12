//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Pedro Silva Dos Santos on 12/08/21.
//

import Foundation
import Domain

func makeAccountModel() -> Accountmodel {
    return Accountmodel(id: "any_id", name: "any_name", email: "any_email", password: "any_password")
}
