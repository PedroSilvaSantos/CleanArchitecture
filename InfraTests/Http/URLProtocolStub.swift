import Foundation

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
