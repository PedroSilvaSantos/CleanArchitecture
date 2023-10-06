import XCTest

class RemoteAddAccount {
    //Quando o valor é de responsabilidade da classe, injetamos o valor nela
    private let url: URL
    private let httpPostClient: HttpPostClient
    
    init(url: URL, httpPostClient: HttpPostClient) {
        self.url = url
        self.httpPostClient = httpPostClient
    }
    
    func add() {
        httpPostClient.post(url: self.url)
    }
}

//Principios do SOLID
//S - Interface segregation
protocol HttpGetClient {
    func get(url: URL)
}

protocol HttpPostClient {
    func post(url: URL)
}


final class RemoteAddAccountTests: XCTestCase {
    func test_() {
        let url = URL(string: "http://any-url.com")
        let httpClientSpy = HttpClientSpy()
        //A instancia da classe chamamos de SUT
        let sut = RemoteAddAccount(url: url!, httpPostClient: httpClientSpy)
        sut.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    //Test Double - Double do valor
    //Spy - versao mocada - fake de producao - cria variavel de referencia
    //Stub -
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}

    
