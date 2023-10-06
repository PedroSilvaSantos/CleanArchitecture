
import Foundation
import XCTest


extension XCTestCase {
    
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        //addTeardownBlock é executado sempre ao final do testes, ele valida se o sut foi desalocado da memoria
        //capturado como referencia fraca
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
