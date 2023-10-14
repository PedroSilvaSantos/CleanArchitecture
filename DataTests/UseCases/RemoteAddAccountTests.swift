import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    
    //padrão do nome: test + nome do metodo que esta sendo testado + o que esta sendo validado
    func test_add_should_call_httpclient_with_correct_ulr() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSUT(url: url)
        sut.addAccount(addAccountModel: makeAddAccountModel()) { _ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
        //XCTAssertEqual(httpClientSpy.callsCount, 1) //validar se é chamado apenas uma vez
    }
    
    func test_add_should_call_httpclient_with_correct_data() {
        let addAccountModel = makeAddAccountModel()
        let (sut, httpClientSpy) = makeSUT()
        sut.addAccount(addAccountModel: addAccountModel) { _ in}
        
        //converter a Model para Data utilizando o Encoder - o Decoder serve para converter o Data para Model
        let data = addAccountModel.modelToData()
        XCTAssertEqual(httpClientSpy.data, data)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_errors() {
        let (sut, httpClientSpy) = makeSUT()
        expect(sut, completWith: .failure(.unexpected)) {
            httpClientSpy.completeWithError(.noConnectivity)
        }
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() {
        let (sut, httpClientSpy) = makeSUT()
        let account = makeAccountModel()
        expect(sut, completWith: .success(makeAccountModel())) {
            httpClientSpy.completWithData(data: account.modelToData()!)
        }
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() {
        let (sut, httpClientSpy) = makeSUT()
        //testes assincrono precisa usar o expectation
        
        expect(sut, completWith: .failure(.unexpected)) {
            httpClientSpy.completWithData(data: makeInvalidData())
        }
    }
    
    func test_add_should_complete_if_sut_has_been_deallocted() {
        let httpClientSpy = HttpClientSpy()
        let url = makeUrl()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: url, httpPostClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?
        //A idéia é que nao deveria executar o callcback, pois estou setando o sut para nil
        //$0 atalho para o valor do primeiro resultado
        sut?.addAccount(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    
    //Return Tupla com SUT e HttpClient
    func makeSUT(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpPostClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    //Completa com a resposta, quando uma ação acontencer
    func expect(_ sut: RemoteAddAccount, completWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        sut.addAccount(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let expectedError)): XCTAssertEqual(expectedError, expectedError, file: file, line:line)
                case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line:line)
                default: XCTFail("Expected \(expectedResult) receive \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action() //O action é a ação que o nosso testes irá fazer
        wait(for: [exp], timeout: 1)
    }
}
