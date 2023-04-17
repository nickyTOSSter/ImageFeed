import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {

    func testDateFormat() throws {
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 1
        dateComponents.day = 15

        let calendar = Calendar(identifier: .gregorian)
        let testDate = calendar.date(from: dateComponents)

        let presenter = ImageListViewPresenter()
        let formattedDate = presenter.formattedDate(testDate)
        print(formattedDate)
        XCTAssertEqual(formattedDate, "15 января 2023 г.")
    }

    func testRowHeighCalculation() throws {
        let presenter = ImageListViewPresenter()
        let cellHeight = presenter.calculateRowHeight(imageWidth: 400, imageHeight: 300, tableViewWidth: 500)
        XCTAssertEqual(cellHeight, 359)
    }

}
