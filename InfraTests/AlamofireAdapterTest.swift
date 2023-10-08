import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    public func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        let json = data?.toJson()
        session.request(url, method: .post,parameters: json, encoding: JSONEncoding.default).responseData { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return completion(.failure(.noConnectivity)) }
            switch dataResponse.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success(let data):
                if statusCode == 200 {
                    completion(.success(data))
                }
            }
        }
    }
}


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
}

//URLProtocol é uma classe
//intercepta URL session, alamofire e qlq outro
class URLProtocolStub: URLProtocol {
    
    //variavel responsavel por guardar o valor retornado no request
    //designer patter Observation
    static var emit: ((URLRequest) -> Void)?
    
    //tratar a return do request
    static var data: Data?
    static var error: Error?
    static var response: HTTPURLResponse?
    
    //precisamos trabalhar com metodos staticos para termos referencia do lado de fora da classe
    //observando o retorno do request, podendo ser chamado do lado de fora da classe
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
    
    //metodo responsavel por setar o return do reequest
    static func simulateRequest(data: Data?, response: HTTPURLResponse?, error: Error?) {
        URLProtocolStub.data = data
        URLProtocolStub.response = response
        URLProtocolStub.error = error
    }
    
    
    //metodos staticos
    override open class func canInit(with request: URLRequest) -> Bool {
        //true - vamos interceptar todos os request
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    //metodos de instancia
    override open func startLoading() {
        //toda logica ficará aqui, simiular com error, falha e sucesso
        URLProtocolStub.emit?(request)
        
        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    override open func stopLoading() {}
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
    
    func expect(_ expectResult: Result<Data, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line){
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

