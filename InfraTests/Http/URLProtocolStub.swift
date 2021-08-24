//
//  URLProtocolStub.swift
//  InfraTests
//
//  Created by Pedro Silva Dos Santos on 24/08/21.
//

import Foundation
import XCTest

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
