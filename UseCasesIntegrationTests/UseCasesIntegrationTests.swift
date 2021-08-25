//
//  UseCasesIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Pedro Silva Dos Santos on 24/08/21.
//

import XCTest
import Data
import Infra
import Domain

class UseCasesIntegrationTests: XCTestCase {

     func test_add_account() {
        let url = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let alamofireAdapter = AlamofireAdapter()
        let sut = RemoteAddAccount(url: url , httpClient: alamofireAdapter)
        
        let accountModel = AddAccountModel(name: "RODRIGO", email: "rodrigo@gmail.com", password:"secret", passwordConfirmation: "secret")
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: accountModel) { result in
            switch result {
            case .failure: XCTFail("Expected sucess got \(result) instead")
            case .success(let account):
                XCTAssertNotNil(account.accessToken)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20)
    }
}
    
