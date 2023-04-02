import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastName: String?
    private init() { }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastName == username {
            return
        }
        task?.cancel()
        lastName = username
        
        guard let token = OAuth2TokenStorage().token else { return }
             
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                completion(.success(self.avatarURL!))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["url": self.avatarURL]
                    )
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
}
