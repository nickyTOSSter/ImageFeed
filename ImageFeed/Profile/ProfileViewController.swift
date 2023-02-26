import UIKit

class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView!
    private var logoutButton: UIButton!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boldFont = UIFont(name: "YSDisplay-Bold", size: 23)!
        let regFont = UIFont(name: "YSDisplay-Medium", size: 13)!
        let ypGrayColor = UIColor(named: "ypGray")!
        
        view.backgroundColor = UIColor(named: "ypBlack")
        
        avatarImageView = createImageView(with: UIImage(named: "Photo"))
        view.addSubview(avatarImageView)
        
        logoutButton = createButton(image: UIImage(named: "ipad.and.arrow.forward"), action: #selector(didTapLogoutButton))
        view.addSubview(logoutButton)
        
        nameLabel = createLabel(text: "Екатерина Новикова", textColor: .white, font: boldFont)
        view.addSubview(nameLabel)
        
        loginNameLabel = createLabel(text: "@ekaterina_nov", textColor: ypGrayColor, font: regFont)
        view.addSubview(loginNameLabel)

        descriptionLabel = createLabel(text: "Hello, world!", textColor: .white, font: regFont)
        view.addSubview(descriptionLabel)
        
        configureConstraits()
    }
        
    private func createImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
    }
    
    private func createButton(image: UIImage?, action: Selector) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage (image, for: .normal)
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
    
    @objc private func didTapLogoutButton() {
        print("Logout")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
