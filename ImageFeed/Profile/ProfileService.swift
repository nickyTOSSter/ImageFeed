import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?

    let urlSession = URLSession.shared

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token {
            return
        }
        task?.cancel()
        lastToken = token

        var request = URLRequest.makeHTTPRequest(path: "me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }

            switch result {
            case .success(let profileResult):
                self.profile = Profile(
                    username: profileResult.username,
                    name: "\(profileResult.firstName) \(profileResult.lastName)",
                    bio: profileResult.bio
                )
                completion(.success(self.profile!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
