import XCTest
import Alamofire

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    public func post(to url: URL) {

    }
}


final class AlamofireAdapterTest: XCTestCase {

    func test_() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        sut.post(to: url)
    }
}


//URLProtocol é uma classe
class URLProtocolStub: URLProtocol {
    override open class func canInit(with request: URLRequest) -> Bool {
        //true - vamos interceptar todos os request
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        //toda logica ficará aqui, simiular com error, falha e sucesso
        
    }

    override open func stopLoading() {}
}
