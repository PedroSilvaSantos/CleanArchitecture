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
        session.request(url, method: .post).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {
    func test_() throws {
        let url = makeurl()
        let configurationTest = URLSessionConfiguration.default
        
        //Seguindo essa configuracao, todas as minhas solicitacoes serao interceptadas na classe URLProtocolStub, e nao nnos servidores de producao
        configurationTest.protocolClasses = [URLProtocolStub.self]
        let sessionTest = Session(configuration: configurationTest)
        
        //Ss testes serao o seguinte, se o Alamofire falhar, o que acontence com a nossa implementacao
        let sut = AlamofireAdapter(session: sessionTest) //injetar no construtor para nao usar o session default da classe de producao, evita de ir ao NetWork para validar as resposta.
        
        sut.post(to: url)//Essa requisicao será interceptada
        
        
        //Como se trata de um metodo assincrono, deveremos chamar nosso expectation para aguardar o completion finalizar
        let exp = expectation(description: "waiting")
        URLProtocolStub.observeRequest { (request) in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 70.0)
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
