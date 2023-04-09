import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    static let shared = ImagesListService()
    private let dateFormatter = ISO8601DateFormatter()

    private init() { }

    func fetchPhotosNextPage() {
        if task != nil {
            return
        }

        let page = nextPage()
        guard let url = urlForRequest(nextPage: page) else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosResult):
                DispatchQueue.main.async {
                    let newPhotos = photosResult.map { photoResult in
                        let photo = Photo(from: photoResult, createdAt: self.dateFormatter.date(from: photoResult.createdAt ?? ""))
                        return photo
                    }
                    self.photos += newPhotos

                    self.lastLoadedPage += 1
                    NotificationCenter.default.post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["newPhotos": newPhotos]
                    )
                }
            case .failure(let error):
                print("error \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()

    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like", httpMethod: "DELETE")
        if isLike {
            request.httpMethod = "POST"
        }
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, _ in
            guard let self = self else { return }
            if let response = response,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300) ~= httpResponse.statusCode {
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(photo: photo)
                        self.photos[index] = newPhoto
                        completion(Result.success(()))
                    }
                }
            } else {
                assertionFailure("Не удалось получить изменение флага isLiked")
            }
        }
        task.resume()
    }

    private func nextPage() -> Int {
        lastLoadedPage + 1
    }

    private func photosPerPage() -> Int {
        10
    }

    private func urlForRequest(nextPage page: Int) -> URL? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/photos"

        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(photosPerPage())")
        ]

        return urlComponents.url
    }
}
