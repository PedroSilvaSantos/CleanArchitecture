import XCTest
import Data
import Infra
import Domain

final class AddAccountIntegrationTests: XCTestCase {
    
    //teste de sucesso na integracao com o componente de producao
    func test_add_account() {
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://clean-node-api.herokuapp.com/api/singup")!
        let sutIntegration = RemoteAddAccount(url: url, httpPostClient: alamofireAdapter)
        let addAccountModelIntegration = AddAccountModel(name: "Julia", email: "julia-any@gmail.com", password: "secret", passwordConfirmation: "secret")
        let exp = expectation(description: "waitiing")
        sutIntegration.addAccount(addAccountModel: addAccountModelIntegration) { resultIntegration in
            switch resultIntegration {
            case .success(let account):
                XCTAssertNotNil(account.id)
                XCTAssertEqual(account.name, addAccountModelIntegration.name)
                XCTAssertEqual(account.email, addAccountModelIntegration.email)
            case .failure(_):
                XCTFail("Expect success got \(resultIntegration) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
}
