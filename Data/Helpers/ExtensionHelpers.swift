import Foundation

//converter Data para Model pelo Codable
extension Data {
    public func dataToModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
