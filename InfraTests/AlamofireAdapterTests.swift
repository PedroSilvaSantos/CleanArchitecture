//
//  InfraTests.swift
//  InfraTests
//
//  Created by Pedro Silva Dos Santos on 12/08/21.
//

import XCTest


class AlamofireAdapter {
    
    func post(to url: URL) {
        
    }
}

class AlamofireAdapterTests: XCTestCase {
    func test_() throws {
        let url = makeurl()
        let sut = AlamofireAdapter()
        sut.post(to: url)
    }
}
