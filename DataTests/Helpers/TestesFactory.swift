//
//  TestesFactory.swift
//  DataTests
//
//  Created by Pedro Silva Dos Santos on 12/08/21.
//

import Foundation

func makeurl() -> URL {
    return URL(string: "http://any_ulr.com.br")!
}

func makeInvalideData() -> Data {
    return Data("invalid_data".utf8)
}
