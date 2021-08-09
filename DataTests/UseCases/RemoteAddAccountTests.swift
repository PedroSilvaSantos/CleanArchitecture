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

        //sut -> system under test
        let (sut, httpClientSpy) = makeSUT(url: url)
        //let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAccountModel()) {_ in }
        
        //Validando a quantidade e o valor da url
        XCTAssertEqual(httpClientSpy.urls, [url])
     }
    
    
    //testando o caso de uso, validando o data
     func test_add_shoul_call_httpClient_with_correct_data() {
        
        let (sut,httpClientSpy) = makeSUT()

        let addAccountModel = makeAccountModel()
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAccountModel()) {_ in }
        
        //metodo validador
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
     }
    
    
    //tetes do callback
    func test_add_should_complete_with_error_if_client_fails() {
       let (sut,httpClientSpy) = makeSUT()
        //implementando o expectation para metodos assyncronos
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAccountModel()) { error in
            XCTAssertEqual(error, .unexpected)
            exp.fulfill()
        }
        httpClientSpy.completionWithError(.noConectivity)
        //aguaradar o fulfill ser chamado
        wait(for: [exp], timeout: 1)
    }
}






//CLASSE LOCAL SIMULANDO A CLASSE REAL-Helps
extension RemoteAddAccountTest {
    
    //padrão de designer pattern: Factory
    func makeAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeSUT(url: URL = URL(string: "http://any_ulr.com.br")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) { //tupla
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    //classe HttpClientSpy para tratar o protocol
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data? //dados genericos que devem ser generalizados
        var completion: ((HttpError) -> Void)?
        
    func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void) {
            self.urls.append(url)
            self.data = data
        self.completion = completion
        }
        
        func completionWithError(_ error: HttpError) {
            completion?(error)
        }
    }
}
    
