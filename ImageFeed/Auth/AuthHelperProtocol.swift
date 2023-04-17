import Foundation

protocol AuthHelperProtocol {
    var configuration: AuthConfiguration { get set }

    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
