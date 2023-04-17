import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {

    func testUserLoggedOutCalled() throws {
        let presenter = ProfilePresenterFake()
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter
        presenter.logOut()
        XCTAssertTrue(viewController.userLoggedOutCalled)
    }

}

final class ProfilePresenterFake: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    func logOut() {
        view?.userLoggedOut()
    }
}

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var userLoggedOutCalled = false

    func userLoggedOut() {
        userLoggedOutCalled = true
    }
}
