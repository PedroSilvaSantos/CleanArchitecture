//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by Pedro Silva Dos Santos on 12/08/21.
//

import Foundation
import Data

//classe HttpClientSpy para tratar o protocol
class HttpClientSpy: HttpPostClient {
    var urls = [URL]()
    var data: Data? //devolve dados genericos que devem ser generalizados
    var completion: ((Result<Data?, HttpError>) -> Void)?
    
func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        self.urls.append(url)
        self.data = data
        self.completion = completion
    }
    
    func completionWithError(_ error: HttpError) {
        completion?(.failure(.noConectivity))
    }
    
    func completionWithData(_ data: Data) {
        completion?(.success(data))//dados genericos
    }
}
