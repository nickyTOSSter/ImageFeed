import XCTest
@testable import ImageFeed

final class ImageFeedTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController {
            let presenter = WebViewPresenterSpy()
            viewController.presenter = presenter
            presenter.view = viewController

            _ = viewController.view

            XCTAssertTrue(presenter.viewDidLoadCalled)
        }

    }

    func testViewControllerCallsLoad() throws {
        let viewController = WebViewViewControllerSpy()
        
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()

        XCTAssertTrue(viewController.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThanOne() throws {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 0.6

        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressVisibleWhenWhenOne() throws {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let progress: Float = 1

        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() throws {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        let url = authHelper.authURL()
        let urlString = url.absoluteString

        XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }

    func testCodeFromURL() throws {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        let url = urlComponents.url!

        let authHelper = AuthHelper()

        let code = authHelper.code(from: url)

        XCTAssertEqual(code, "test code")
    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: ImageFeed.WebViewViewControllerProtocol?
    var authHelper: ImageFeed.AuthHelperProtocol = AuthHelper()

    var viewDidLoadCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {
    }

    func code(from url: URL) -> String? {
        nil
    }
}

final class WebViewViewControllerSpy: UIViewController, WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {
    }

    func setProgressHidden(_ isHidden: Bool) {
    }
}
