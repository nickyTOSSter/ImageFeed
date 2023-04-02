import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView!
    private var logoutButton: UIButton!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        let boldFont = UIFont(name: "YSDisplay-Bold", size: 23)!
        let regFont = UIFont(name: "YSDisplay-Medium", size: 13)!
        let ypGrayColor = UIColor(named: "ypGray")!

        view.backgroundColor = UIColor(named: "ypBlack")

        avatarImageView = createImageView(with: UIImage(named: "Photo"))
        view.addSubview(avatarImageView)

        logoutButton = createButton(
            image: UIImage(named: "ipad.and.arrow.forward"),
            action: #selector(didTapLogoutButton)
        )
        view.addSubview(logoutButton)

        nameLabel = createLabel(text: "Екатерина Новикова", textColor: .white, font: boldFont)
        view.addSubview(nameLabel)

        loginNameLabel = createLabel(text: "@ekaterina_nov", textColor: ypGrayColor, font: regFont)
        view.addSubview(loginNameLabel)

        descriptionLabel = createLabel(text: "Hello, world!", textColor: .white, font: regFont)
        view.addSubview(descriptionLabel)

        configureConstraits()
        updateProfileDetails(profile: profileService.profile)
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                })
        updateAvatar()
    }

    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }

        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Photo")
        )
    }

    private func createImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.backgroundColor = UIColor(named: "ypBlack")
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }

    private func createButton(image: UIImage?, action: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func createLabel(text: String, textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = textColor
        label.font = font
        return label
    }

    private func configureConstraits() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),

            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8)
        ])

    }

    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.username
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    @objc private func didTapLogoutButton() {
        print("Logout")
    }
}
