import Foundation

public struct SignUpViewModel {
    public var name: String?
    public var email: String?
    public var password: String?
    public var confirmPassword: String?
    
    public init(name: String? = nil, email: String? = nil, password: String? = nil, confirmPassword: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}
    
