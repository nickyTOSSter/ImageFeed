import UIKit
import Kingfisher
import ProgressHUD

final class ImageListViewController: UIViewController, ImageListViewControllerProtocol {
    @IBOutlet private var tableView: UITableView!
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServerObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []

    var presenter: ImageListViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImageListViewPresenter()
        presenter?.view = self

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServerObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.updateTableViewAnimated()
            })
        imagesListService.fetchPhotosNextPage()
    }
}

extension ImageListViewController {
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count

        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { row in
                    return IndexPath(row: row, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }

    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let imageUrl = URL(string: photos[indexPath.row].thumbImageURL) else {
            return
        }

        let photo = photos[indexPath.row]
        cell.delegate = self
        cell.setIsLiked(photo.isLiked)
        cell.dateLabel.text = presenter?.formattedDate(photo.createdAt)
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Stub")) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else { return }
            viewController.fullImageURL = URL(string: photos[indexPath.row].largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        if let height = presenter?.calculateRowHeight(
            imageWidth: image.size.width,
            imageHeight: image.size.height,
            tableViewWidth: tableView.bounds.width
        ) {
            return height
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)

            case .failure(_):
                UIBlockingProgressHUD.dismiss()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol? { get set }
}


