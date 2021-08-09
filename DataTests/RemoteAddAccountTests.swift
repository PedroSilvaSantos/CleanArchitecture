//
//  DataTests.swift
//  DataTests
//
//  Created by Pedro Silva Dos Santos on 04/08/21.
//

import XCTest
import Domain

//classe local para parar o error
class RemoteAddAccount {
    
    //variavel interna
    private var url: URL
    var httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel) {
        //transformando o modelo em data
        let data = try? JSONEncoder().encode(addAccountModel)
        httpClient.post(to: url, with: data)
    }
}

//PROTOCOL
protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}


class RemoteAddAccountTest: XCTestCase {
    
    //testando o caso de uso, validando a url
     func test_add_shoul_call_httpClient_with_correct_url() {
        
        //simulando uma url
        let url = URL(string: "http://any_ulr.com.br")!
        
        
        //protocolo
        //let httpClientSpy = HttpClientSpy()
        
        
        //sut -> system under test
        let (sut, httpClientSpy) = makeSUT(url: url)
        //let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAccountModel())
        
        //metodo validador
        XCTAssertEqual(httpClientSpy.url, url)
     }
    
    
    //testando o caso de uso, validando o data
     func test_add_shoul_call_httpClient_with_correct_data() {
        
        let (sut,httpClientSpy) = makeSUT()
        
        //simulando uma url
        //let url = URL(string: "http://any_ulr.com.br")!
        
        
        //protocolo
        //let httpClientSpy = HttpClientSpy()
        
    
        //sut -> system under test
        //let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAccountModel())
        
        //transformar meus dados retornando da classe em data
        let data = try? JSONEncoder().encode(makeAccountModel())
        
        //metodo validador
        XCTAssertEqual(httpClientSpy.data, data)
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
        var url: URL?
        var data: Data? //dados genericos que devem ser generalizados
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
