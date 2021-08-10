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
        //implementando o expectation para metodos assyncronos
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completionWithError(.noConectivity)
        //aguaradar o fulfill ser chamado
        wait(for: [exp], timeout: 1)
    }
    
    //case de sucesso no callback
    func test_add_should_complete_with_account_complete_whith_data() {
        let (sut,httpClientSpy) = makeSUT()
         let exp = expectation(description: "waiting")
        let expectedAccount = makeAccountModel()
         sut.add(addAccountModel: makeAddAccountModel()) { result in
             switch result {
             case .failure: XCTFail("Expected sucess received \(result) instead")
             case .success(let receivedAccount): XCTAssertEqual(receivedAccount, expectedAccount)
                print(receivedAccount, expectedAccount)
             }
             exp.fulfill()
         }
        //devolver um data de account, antes teremos que transformar o retorno para um data
        httpClientSpy.completionWithData(expectedAccount.toData()!)
         wait(for: [exp], timeout: 1)
    }
    
    //tetes de sucesso no callback, mas falhas nos dados retornados
    func test_add_should_complete_with_account_complete_whith_data_with_error_data() {
       let (sut,httpClientSpy) = makeSUT()
        //implementando o expectation para metodos assyncronos
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completionWithData(Data("Invalide_data".utf8))
        wait(for: [exp], timeout: 1)
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
    
