import UIKit
import XCTest
@testable import iOSUI


final class SignUpViewControllerTests: XCTestCase {

    func test_loagind_is_hidden_on_start() {
        
        //criar instancia da Storyboard
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        sut.loadViewIfNeeded() //carregar a viewController
        XCTAssertEqual(sut.loadingIndicator.isAnimating, false)
       
    }
}
