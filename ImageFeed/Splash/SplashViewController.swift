import UIKit

final class SplashViewController: UIViewController {

    private let authViewControllerStoryboardID = "AuthViewController"
    private let tokenStorage = OAuth2TokenStorage()
    private let authService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "ypBlack")
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.image = UIImage(named: "splash_screen_logo")
    }

    override func viewDidAppear(_ animated: Bool) {
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            presentViewController(with: authViewControllerStoryboardID)
        }
    }

    private func presentViewController(with storyboardID: String) {
        guard let viewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: storyboardID)
                as? AuthViewController else { return }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {

    func authViewController(_ viewController: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        authService.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }

    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self.fetchProfileImageURL(profile)
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }

    private func fetchProfileImageURL(_ profile: Profile) {
        profileImageService.fetchProfileImageURL(username: profile.username)
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
}
