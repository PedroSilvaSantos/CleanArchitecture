import Foundation

//Caso retorne com sucesso, a aplicacao devolverá uma conta contendo esses dados populados
public struct AccountModel: Encodable {
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


extension AddAccountModel {
    public func modelToData() -> Data? {
        return try? JSONEncoder().encode(self)
        //O self é a propria instacia dessa classe
    }
    
//    public func dataToModel(jsonData: Data?) -> Data? {
//        return try? JSONDecoder().decode([], from: jsonData)
//        //O self é a propria instacia dessa classe
//    }
}
