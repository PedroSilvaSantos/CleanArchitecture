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
    func post(to url: URL, with data: Data?) {
        guard let data = data else { return }
        //Receber um data e transformalo em um array de objetos
        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any]
        
        //outra opcao para tratar o campo ocional do data
       // let json =  data == nil ? nil : try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String : Any]
        session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).resume()
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
}


extension AlamofireAdapterTests {
    func makeSut() -> AlamofireAdapter {
        
        let configurationTest = URLSessionConfiguration.default
        
        //Seguindo essa configuracao, todas as minhas solicitacoes serao interceptadas na classe URLProtocolStub, e nao nnos servidores de producao
        configurationTest.protocolClasses = [URLProtocolStub.self]
        let sessionTest = Session(configuration: configurationTest)
        
        //Ss testes serao o seguinte, se o Alamofire falhar, o que acontence com a nossa implementacao
        return AlamofireAdapter(session: sessionTest) //injetar no construtor para nao usar o session default da classe de producao, evita de ir ao NetWork para validar as resposta.
    }
    
    func test_request_for(url: URL?, data: Data?, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        guard let url = url else {return}
        sut.post(to: url, with: data)
        let exp = expectation(description: "waiting")
        URLProtocolStub.observeRequest { (request) in
            action(request)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

//MARK: Interceptar os Request
class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    
    //Criando um escutador (Observer) e passando via completion para metodo de teste
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
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
    }
    
    override open func stopLoading() {}
}
