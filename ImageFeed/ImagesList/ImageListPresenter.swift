import Foundation

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    var view: ImageListViewControllerProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()


    func calculateRowHeight(imageWidth: CGFloat, imageHeight: CGFloat, tableViewWidth: CGFloat) -> CGFloat {
        let horizontalIndents: CGFloat = 32
        let verticalIndents: CGFloat = 8
        let imageViewWidth = tableViewWidth - horizontalIndents
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + verticalIndents
        return cellHeight
    }

    func formattedDate(_ date: Date?) -> String {
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }

}
