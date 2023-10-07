import XCTest
import Alamofire

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    public func post(to url: URL, with data: Data?) {
        let json = data == nil ? nil : try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
        session.request(url, method: .post,parameters: json, encoding: JSONEncoding.default).resume()
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
}

//URLProtocol é uma classe
//intercepta URL session, alamofire e qlq outro
class URLProtocolStub: URLProtocol {
    
    //variavel responsavel por guardar o valor retornado no request
    //designer patter Observation
    static var emit: ((URLRequest) -> Void)?
    
    //precisamos trabalhar com metodos staticos para termos referencia do lado de fora da classe
    //observando o retorno do request, podendo ser chamado do lado de fora da classe
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
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
        sut.post(to: url, with: data)
        //teste assincrono, devemos usar o expectation
        let exp = expectation(description: "waiting")
        URLProtocolStub.observerRequest { request in
            action(request)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
