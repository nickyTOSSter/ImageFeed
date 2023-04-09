import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    weak var delegate: ImagesListCellDelegate?

    @IBAction func likeButtonPressed(sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }

    func setIsLiked(_ isLiked: Bool) {
        let icon = UIImage(named: isLiked ? "like_button_on" : "like_button_off")
        likeButton.setImage(icon, for: .normal)
    }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
