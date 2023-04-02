import UIKit

final class SplashViewController: UIViewController {

    private let authScreenIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    private let tokenStorage = OAuth2TokenStorage()
    private let authService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: authScreenIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authScreenIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let vc = navigationController.viewControllers.first as? AuthViewController
            else {
                fatalError("Failed to prepare for \(authScreenIdentifier)")
            }
            
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func switchToTabBarController() {
        
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
       
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
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
                // TODO [Sprint 11] Показать ошибку
                self.showAlert()
                break
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
                // TODO [Sprint 11] Показать ошибку
                self.showAlert()
                break
            }
        }
    }
    
    private func fetchProfileImageURL(_ profile: Profile) {
        print("going to profileImageService.fetchProfileImageURL")
        profileImageService.fetchProfileImageURL(username: profile.username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let avatarURL):
                print("avatar url: \(avatarURL)")
            case .failure:
                print("Failed to fetch avatar")
            }

        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
    
}
