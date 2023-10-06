import Foundation

//Principios do SOLID
//S - Interface segregation
public protocol HttpGetClient {
    func get(url: URL)
}

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data,HttpError>) -> Void)
}
