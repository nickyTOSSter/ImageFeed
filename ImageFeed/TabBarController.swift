import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListVC = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )

        self.viewControllers = [imageListVC, profileVC]
    }
}
