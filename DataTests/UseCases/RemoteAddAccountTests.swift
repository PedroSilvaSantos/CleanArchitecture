//
//  DataTests.swift
//  DataTests
//
//  Created by Pedro Silva Dos Santos on 04/08/21.
//

import XCTest
import Domain
import Data


class RemoteAddAccountTest: XCTestCase {
    
    //testando o caso de uso, validando a url
     func test_add_shoul_call_httpClient_with_correct_url() {
        
        //simulando uma url
        let url = URL(string: "http://any_ulr.com.br")!

        //sut -> system under test - passando uma tupla
        let (sut, httpClientSpy) = makeSUT(url: url)
        //let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAddAccountModel()) {_ in }
        
        //Validando a quantidade e o valor da url
        XCTAssertEqual(httpClientSpy.urls, [url])
     }
    
    
    //testando o caso de uso, validando o data
     func test_add_shoul_call_httpClient_with_correct_data() {
        
        let (sut,httpClientSpy) = makeSUT()

        let addAccountModel = makeAddAccountModel()
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAddAccountModel()) {_ in }
        
        //metodo validador
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
     }
    
    
    //tetes do callback
    func test_add_should_complete_with_error_if_client_fails() {
       let (sut,httpClientSpy) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected)) {
            //executa a action no caso de error
            httpClientSpy.completionWithError(.noConectivity)
        }
    }
    
    //case de sucesso no callback
    func test_add_should_complete_with_account_complete_whith_data() {
        let (sut,httpClientSpy) = makeSUT()
        let expectedAccount = makeAccountModel()
        expect(sut, completeWith: .success(expectedAccount)) {
            httpClientSpy.completionWithData(expectedAccount.toData()!)
        }
    }
    
    //tetes de sucesso no callback, mas falhas nos dados retornados
    func test_add_should_complete_with_account_complete_whith_data_with_error_data() {
       let (sut,httpClientSpy) = makeSUT()
        expect(sut, completeWith: .failure(.unexpected)) {
            httpClientSpy.completionWithData(Data("Invalide_data".utf8))
        }
    }
   }


//CLASSE LOCAL SIMULANDO A CLASSE REAL-Helps
extension RemoteAddAccountTest {
    
    //padrão de designer pattern: Factory
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeAccountModel() -> Accountmodel {
        return Accountmodel(id: "any_id", name: "any_name", email: "any_email", password: "any_password")
    }
    
    func makeSUT(url: URL = URL(string: "http://any_ulr.com.br")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) { //a resposta será um tupla
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    //enxugando os metodos de testes
    //eu espero que a SUT complete com resultado quando alguma coisa acontencer
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<Accountmodel, DomainErros>, when action: ()-> Void ){
         let exp = expectation(description: "waiting")
        let expectedAccount = makeAccountModel()
         sut.add(addAccountModel: makeAddAccountModel()) { receveidResult in
            
            //comparando os dois results: expectedResult com receveidResult
             switch (expectedResult, receveidResult) {
            //primeiro caso, ambos vão falhar
             case (.failure(let expectedError), .failure(let receveidError)): XCTAssertEqual(expectedError, receveidError)
             case (.success(let expectedAccount), .success(let receveidAccount)): XCTAssertEqual(expectedAccount, receveidAccount)
                
             //default será qlq outro caso diferenre dos dois cenarios de sucess e fail
             default : XCTFail("Expected \(expectedResult) error received  \(receveidResult) instead")
             }
             exp.fulfill()
         }
        action()
        wait(for: [exp], timeout: 1)
    }
    
    
    //classe HttpClientSpy para tratar o protocol
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data? //dados genericos que devem ser generalizados
        var completion: ((Result<Data, HttpError>) -> Void)?
        
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completionWithError(_ error: HttpError) {
            completion?(.failure(.noConectivity))
        }
        
        func completionWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}
    
