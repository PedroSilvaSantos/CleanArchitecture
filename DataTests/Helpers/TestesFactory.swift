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

func makeValideData() -> Data {
    return Data("{\"name\":\"Pedro\"}".utf8)
}

func makeEmptyData() -> Data {
    return Data()
}

func makeError() -> Error {
    return NSError(domain: "any_error", code: 0, userInfo: nil)
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: makeurl(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
