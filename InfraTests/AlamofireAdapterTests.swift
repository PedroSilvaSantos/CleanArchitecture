//
//  InfraTests.swift
//  InfraTests
//
//  Created by Pedro Silva Dos Santos on 12/08/21.
//


import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data , HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { (dataResponse) in
            switch dataResponse.result {
                case .failure: completion(.failure(.noConectivity))
            case .success: break
            }
        }
    }
}

class AlamofireAdapterTests: XCTestCase {
    
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeurl()
        test_request_for(url: url, data: makeValideData()) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
        }
    }
    
    
    func test_post_should_make_request_with_no_data() {
        test_request_for(url: nil , data: nil) { (request) in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
    func test_post_should_complet_with_error_when_request_completes_with_error() {
        let sut = makeSut()
        URLProtocolStub.simulate(data: nil, response: nil, error: makeError())
        
        //como o metodo é assincrono, vamos criar o expectation novamente
        let exp = expectation(description: "waiting")
        
        //receberá um completion com result, data e error
        sut.post(to: makeurl(), with: makeValideData()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .noConectivity)
            case .success: XCTFail("Expected error got \(result) instead")
            }
            exp.fulfill()
        }
        //aguardando o metodo chamar
        wait(for: [exp], timeout: 1)
    }
}


extension AlamofireAdapterTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> AlamofireAdapter {
        
        let configurationTest = URLSessionConfiguration.default
        
        //Seguindo essa configuracao, todas as minhas solicitacoes serao interceptadas na classe URLProtocolStub, e nao nnos servidores de producao
        configurationTest.protocolClasses = [URLProtocolStub.self]
        let sessionTest = Session(configuration: configurationTest)
        
        //Os testes serao o seguinte, se o Alamofire falhar, o que acontence com a nossa implementacao
        let sut = AlamofireAdapter(session: sessionTest) //injetar no construtor para nao usar o session default da classe de producao, evita de ir ao NetWork para validar as resposta.
        
        //Testando o sut para verificar se tem memory leak
        checkMemoryleak(for: sut, file: file, line: line)
        return sut
    }
    
    
    func test_request_for(url: URL?, data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        guard let url = url else {return}
        
        let exp = expectation(description: "waiting")
        
        //o fulfill agora vai aguardar o completion do alamofire rodar
        sut.post(to: url, with: data) { _ in exp.fulfill()}
        
        var request: URLRequest?
        URLProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        
        //depois de tudo concluido, chamo o action
        if let request = request {
            action(request)
        }
    }
}

//MARK: Interceptar os Request
class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    
    static var data: Data?
    static var response: HTTPURLResponse?
    static var error: Error?
    
    //Criando um escutador (Observer) e passando via completion para metodo de teste
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }
    
    static func simulate(data: Data?, response: HTTPURLResponse?, error: Error?) {
        URLProtocolStub.data = data
        URLProtocolStub.response = response
        URLProtocolStub.error = error
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true //return true -> significa que eu quero interceptar todas as requisicoes feita em ambiente de testes
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print(request)
        return request
    }
    
    override open func startLoading() {
        //Quando estiver pronto, devo executar o completion passando o request da chamada
        URLProtocolStub.emit?(request)
        
        //testando o response
        if let data = URLProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = URLProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        //completar o request apos finalizar o proceso
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override open func stopLoading() {}
}
