import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    
    //padrão do nome: test + nome do metodo que esta sendo testado + o que esta sendo validado
    func test_add_should_call_httpclient_with_correct_ulr() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSUT(url: url)
        sut.add(addAccountModel: makeAddAccountModel())
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpclient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut, httpClientSpy) = makeSUT()
        sut.add(addAccountModel: addAccountModel)
        
        //converter a Model para Data utilizando o Encoder - o Decoder serve para converter o Data para Model
        let data = addAccountModel.modelToData()
        XCTAssertEqual(httpClientSpy.data, data)
    }
}

    
extension RemoteAddAccountTests {
    //colocar todos os helps aqui para organizar
    class HttpClientSpy: HttpPostClient {
        
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
    
    //Design Patterns - Factory
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@gmail.com", password: "123456", passwordConfirmation: "123456")
    }
    
    //Return Tupla com SUT e HttpClient
    func makeSUT(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
}
