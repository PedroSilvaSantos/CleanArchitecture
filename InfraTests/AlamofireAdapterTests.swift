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
        session.request(url).resume()
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
        
        URLProtocolStub.observeRequest { (request) in
            XCTAssertEqual(url, request.url)
        }
    }
}

//MARK: Interceptar os Request
class URLProtocolStub: URLProtocol {
    static var completion: ((URLRequest) -> Void)?
    
    //Criando um escutador (Observer) e passando via completion para metodo de teste
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.completion = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true //return true -> significa que eu quero interceptar todas as requisicoes feita em ambiente de testes
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print(request)
        return request
    }
    
    override open func startLoading() {}
    
    override open func stopLoading() {}
}











//    public init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?)
//    open var client: URLProtocolClient? { get }
//    open var request: URLRequest { get }
//    @NSCopying open var cachedResponse: CachedURLResponse? { get }
//
//    open class func canInit(with request: URLRequest) -> Bool
//    open class func canonicalRequest(for request: URLRequest) -> URLRequest
//    open class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool
//    open func startLoading()
//    open func stopLoading()
//    open class func property(forKey key: String, in request: URLRequest) -> Any?
//    open class func setProperty(_ value: Any, forKey key: String, in request: NSMutableURLRequest)
//    open class func removeProperty(forKey key: String, in request: NSMutableURLRequest)
//    open class func registerClass(_ protocolClass: AnyClass) -> Bool
//    open class func unregisterClass(_ protocolClass: AnyClass)
