import Foundation

//Em caso de sucesso ele develverá um AccountModel e caso de error deveolverar o Error
//Nao retorna nada - Void
protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, Error>) -> Void)

}


//Operacao assincrona - temos que aguardar um servico responder
//A api espera receber esses dados
struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}
