import XCTest

class RemoteAddAccount {
    //Quando o valor é de responsabilidade da classe, injetamos o valor nela
    private let url: URL
    private let httpClient: HttpClient
    
    init(url: URL, httpClient: HttpClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: self.url)
    }
}

protocol HttpClient {
    func post(url: URL)
}

final class RemoteAddAccountTests: XCTestCase {
    func test_() {
        let url = URL(string: "http://any-url.com")
        let httpClientSpy = HttpClientSpy()
        //A instancia da classe chamamos de SUT
        let sut = RemoteAddAccount(url: url!, httpClient: httpClientSpy)
        sut.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    //Test Double - Double do valor
    //Spy - versao mocada - fake de producao - cria variavel de referencia
    //Stub -
    class HttpClientSpy: HttpClient {
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}

    
