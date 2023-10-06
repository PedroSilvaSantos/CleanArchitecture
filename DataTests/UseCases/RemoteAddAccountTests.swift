import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    
    //padrão do nome: test + nome do metodo que esta sendo testado + o que esta sendo validado
    func test_add_should_call_httpclient_with_correct_ulr() {
        let url = makeUrl()
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
        expect(sut, completWith: .failure(.unexpected)) {
            httpClientSpy.completeWithError(.noConnectivity)
        }
    }
    
    func test_add_should_complet_with_account_if_client_completes_with_valid_data() {
        let (sut, httpClientSpy) = makeSUT()
        let account = makeAccountModel()
        expect(sut, completWith: .success(makeAccountModel())) {
            httpClientSpy.completWithData(data: account.modelToData()!)
        }
    }
    
    func test_add_should_complet_with_error_if_client_completes_with_invalid_data() {
        let (sut, httpClientSpy) = makeSUT()
        //testes assincrono precisa usar o expectation
        
        expect(sut, completWith: .failure(.unexpected)) {
            httpClientSpy.completWithData(data: makeInvalidData())
        }
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
        
        func completWithData(data: Data) {
            completion?(.success(data))
        }
    }
    
    //Design Patterns - Factory
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@gmail.com", password: "123456", passwordConfirmation: "123456")
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "01", name: "any_name", email: "any_email@gmail.com", password: "123456")
    }
    
    //Return Tupla com SUT e HttpClient
    func makeSUT(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func makeInvalidData() -> Data {
        return Data("invalid_data".utf8)
    }
    
    func makeUrl() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    //Completa com a resposta, quando uma ação acontencer
    func expect(_ sut: RemoteAddAccount, completWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void) {
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
                case (.failure(let expectedError), .failure(let expectedError)): XCTAssertEqual(expectedError, expectedError)
                case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData)
                default: XCTFail("Expected \(expectedResult) receive \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action() //O action é a ação que o nosso testes irá fazer
        wait(for: [exp], timeout: 1)
    }
}
