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
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
