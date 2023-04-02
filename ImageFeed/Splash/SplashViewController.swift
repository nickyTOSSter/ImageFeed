import UIKit

final class SplashViewController: UIViewController {

    private let authScreenIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    private let tokenStorage = OAuth2TokenStorage()
    private let authService = OAuth2Service.shared
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = tokenStorage.token {
            switchToTabBarController()
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
        authService.fetchOAuthToken(code) { [weak self] result in
            switch result {
            case .success:
                self?.switchToTabBarController()
            case .failure:
                fatalError("Failed to retrieve token")
            }
        }
    }
}
