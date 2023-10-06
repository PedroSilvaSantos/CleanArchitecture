import Foundation

//Em caso de sucesso ele develverá um AccountModel e caso de error deveolverar o Error
//Nao retorna nada - Void
public protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)

}


//Operacao assincrona - temos que aguardar um servico responder
//A api espera receber esses dados
public struct AddAccountModel {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
}
