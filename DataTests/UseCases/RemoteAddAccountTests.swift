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
        let url = makeurl()

        //sut -> system under test - passando uma tupla
        let (sut, httpClientSpy) = makeSUT(url: url)
        //let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        //metodo add chama um metodo no httpClient
        sut.add(addAccountModel: makeAddAccountModel()) {_ in } //passando nada no completion
        
        //Validando a quantidade pelo array de url e validando o valor da url
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
    
    
    //testes do callback
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
            httpClientSpy.completionWithData(makeInvalideData())
     }
    }
    
    ///MARK: testes de falha dealoc, não deve executar o completion caso o sut estiver null
    func test_add_should_not_complete_if_sut_has_been_deallocted() {
       let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeurl() , httpClient: httpClientSpy)
        var result: Result<Accountmodel, DomainErros>?
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil
        httpClientSpy.completionWithError(.noConectivity)
        XCTAssertNil(result)
   }
}


//CLASSE LOCAL SIMULANDO A CLASSE REAL-Helps
extension RemoteAddAccountTest {
    
    //padrão de designer pattern: Factory
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email", password: "any_password", passwordConfirmation: "any_password")
    }
    
    ///MARK: construcao do SUT
    func makeSUT(url: URL = URL(string: "http://any_ulr.com.br")!,file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) { //a resposta será um tupla
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)//classe concreta, não é nulable
        
        //testando memory leak dentro das classes
        //para funcionar deveremos colocar o SUT como [weak suv], referencia fraca, dessa forma poderá ser desalocada ao termino da classe
        checkMemoryleak(for: sut,file: file, line: line)
        checkMemoryleak(for: httpClientSpy,file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    //enxugando os metodos de testes
    //eu espero que a SUT complete com resultado quando alguma coisa acontencer
    //Se o retorno do metodo add for error, o expectedResult deverá ser um erro tbm
    //file: StaticString = #filePath, line, pegando a linha que parou o erro
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<Accountmodel, DomainErros>, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line){
         let exp = expectation(description: "waiting")
         let expectedAccount = makeAccountModel()
         sut.add(addAccountModel: makeAddAccountModel()) { receveidResult in
            
            //comparando os dois results: expectedResult com receveidResult
             switch (expectedResult, receveidResult) {
            //primeiro caso, ambos vão falhar
             case (.failure(let expectedError), .failure(let receveidError)): XCTAssertEqual(expectedError, receveidError, file: file, line: line)
             case (.success(let expectedAccount), .success(let receveidAccount)): XCTAssertEqual(expectedAccount, receveidAccount, file: file, line: line)
                
             //default será qlq outro caso diferenre dos dois cenarios de sucess e fail
             default : XCTFail("Expected \(expectedResult) error received  \(receveidResult) instead", file: file, line: line)
             }
             exp.fulfill()
         }
        action()
        wait(for: [exp], timeout: 1)
    }
}
    
