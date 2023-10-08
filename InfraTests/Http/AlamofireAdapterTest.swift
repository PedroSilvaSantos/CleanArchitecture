import XCTest
import Alamofire
import Data
import Infra

final class AlamofireAdapterTest: XCTestCase {
    
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        testRequestFor(url: url, data: makeValidData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_make_request_with_no_data() {
        testRequestFor(url: makeUrl(), data: nil) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_error() {
        expect(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError()))
        expect(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expect(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expect(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expect(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expect(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
    
    func test_post_should_complete_with_data_when_request_completes_with_200() {
        expect(.success(makeValidData()), when:(data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
    
    func test_post_should_complete_with_data_when_request_completes_with_204() {
        expect(.success(nil), when:(data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expect(.success(nil), when:(data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expect(.success(nil), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_400() {
        expect(.failure(.badRequest), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expect(.failure(.unauthorized), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expect(.failure(.forbidden), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
        expect(.failure(.badRequest), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 450), error: nil))
        expect(.failure(.badRequest), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 499), error: nil))
    }
    
    func test_post_should_complete_with_error_when_request_completes_with_500() {
        expect(.failure(.serveError), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil))
        expect(.failure(.serveError), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 550), error: nil))
        expect(.failure(.serveError), when:(data: makeValidData(), response: makeHttpResponse(statusCode: 599), error: nil))
    }
}

extension AlamofireAdapterTest {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url:URL, data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.post(to: url, with: data) {_ in exp.fulfill()}
        //teste assincrono, devemos usar o expectation
        var request: URLRequest?
        URLProtocolStub.observerRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expect(_ expectResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line){
        let sut = makeSut()
        URLProtocolStub.simulateRequest(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.post(to: makeUrl(), with: makeValidData()) { receivedResult in
            switch (expectResult, receivedResult) {
            case (.failure(let expectError), .failure(let receivedError)): XCTAssertEqual(expectError, receivedError, file: file, line: line)
            case (.success(let expectData), .success(let receivedData)): XCTAssertEqual(expectData, receivedData, file: file, line: line)
            default: XCTFail("Expected \(expectResult) got \(receivedResult) instead", file: file, line: line)
                
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
/*
 Caso de testes
 Valido
 Data  |  Response  |  Error
 ok         ok          x
 x           x          ok
 
 InValido
 Data  |  Response  |  Error
 ok         ok          ok
 ok          x          ok
 ok          x          x
 x           ok         ok
 x           ok         x
 x           x          x
 */

