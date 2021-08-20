//
//  TestesExtensions.swift
//  DataTests
//
//  Created by Pedro Silva Dos Santos on 11/08/21.
//

import Foundation
import XCTest

extension XCTestCase {
    ///MARK: testes de memory leak
    func checkMemoryleak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line)  {
        //addTeardownBlock é executado sempre ao final do testes
        addTeardownBlock {[weak instance] in //deixei minha classe com referencia fraca para pode testar o memory leak
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
