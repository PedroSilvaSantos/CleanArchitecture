import XCTest
import Alamofire

final class AlamofireAdapterTest: XCTestCase {

    
    class AlamofireAdapter {
        
        private var session: Session
        
        init(session: Session = .default) {
            self.session = session
        }
        
        func post(to url: URL) {
           
        }
    }
    
    func test_() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration) //criando uma session local para pode interceptar as requisicoes
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
    }

}


//class URLProtocol
//validar o alamofire com os metodos abaixo
class URLProtocolStub: URLProtocol {
    open override class func canInit(with request: URLRequest) -> Bool {
        //true - quero interceptar todas as requisicoes
        return true
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    open override func startLoading() {
        
    }
    
    open override func stopLoading() {}
}
