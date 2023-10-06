import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    
    //padrão do nome: test + nome do metodo que esta sendo testado + o que esta sendo validado
    func test_add_should_call_httpclient_with_correct_ulr() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSUT(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
        //XCTAssertEqual(httpClientSpy.callsCount, 1) //validar se é chamado apenas uma vez
    }
    
    func test_add_should_call_httpclient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut, httpClientSpy) = makeSUT()
        sut.add(addAccountModel: addAccountModel) { _ in}
        
        //converter a Model para Data utilizando o Encoder - o Decoder serve para converter o Data para Model
        let data = addAccountModel.modelToData()
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_add_should_complet_with_error_if_client_completes_with_errors() {
        let (sut, httpClientSpy) = makeSUT()
        //testes assincrono precisa usar o expectation
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complet_with_account_if_client_completes_with_data() {
        let (sut, httpClientSpy) = makeSUT()
        //testes assincrono precisa usar o expectation
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
}

    
extension RemoteAddAccountTests {
    //colocar todos os helps aqui para organizar
    class HttpClientSpy: HttpPostClient {

        var urls = [URL]() //dessa forma podemos validar a igualdade e a quantidade ao mesmo tempo
        var data: Data?
        var completion: ((Result<Data,HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data,HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
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
