import Foundation

//Principios do SOLID
//S - Interface segregation
public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?,HttpError>) -> Void)
}
