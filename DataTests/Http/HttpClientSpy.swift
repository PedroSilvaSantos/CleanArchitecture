
import Foundation
import Data

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
