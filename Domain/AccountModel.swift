import Foundation

//Caso retorne com sucesso, a aplicacao devolverá uma conta contendo esses dados populados
public struct AccountModel {
    public var id: String
    public var name: String
    public var email: String
    public var password: String
    
    
    //Ao deixar a classe publica perdemos acesso ao construtor, por isso, tivemos que recriar um novo
    public init(id: String, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
