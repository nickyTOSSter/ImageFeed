import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    func logOut() {
        OAuth2Service.shared.logOut()
        WebViewViewController.clean()
        view?.userLoggedOut()
    }
}

