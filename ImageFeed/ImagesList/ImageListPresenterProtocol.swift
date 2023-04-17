import Foundation

protocol ImageListViewPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }

    func calculateRowHeight(imageWidth: CGFloat, imageHeight: CGFloat, tableViewWidth: CGFloat) -> CGFloat
    func formattedDate(_ date: Date?) -> String
}
