import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serveError
    case unauthorized
    case forbidden
}
