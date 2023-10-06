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
    
    //padrão do nome: test + nome do metodo que esta sendo testado + o que esta sendo validado
    func test_add_should_call_httpclient_with_correct_ulr() {
        let url = URL(string: "http://any-url.com")
        let httpClientSpy = HttpClientSpy()
        //A instancia da classe chamamos de SUT
        let sut = RemoteAddAccount(url: url!, httpPostClient: httpClientSpy)
        sut.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }
}

    
extension RemoteAddAccountTests {
    //colocar todos os helps aqui para organizar
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        
        func post(url: URL) {
            self.url = url
        }
    }
}
