//
//  InfraTests.swift
//  InfraTests
//
//  Created by Pedro Silva Dos Santos on 12/08/21.
//


import XCTest
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
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
