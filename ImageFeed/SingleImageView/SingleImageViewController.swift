import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    var fullImageURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }

    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL, placeholder: UIImage(named: "Stub")) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                scrollView.minimumZoomScale = 0.1
                scrollView.maximumZoomScale = 1.25
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }

    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать еще раз?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.setImage()
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true)
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let imageToShare = imageView.image else {
            return
        }

        let activity = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activity, animated: true)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard  let image = image else {
            return
        }

        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let xPoint = (newContentSize.width - visibleRectSize.width) / 2
        let yPoint = (newContentSize.height - visibleRectSize.height) / 2

        scrollView.setContentOffset(CGPoint(x: xPoint, y: yPoint), animated: false)
    }

    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
