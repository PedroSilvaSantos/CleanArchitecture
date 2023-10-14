import Foundation

public protocol Model: Codable, Equatable {}


public extension Model {
    func modelToData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
