import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool

    init(from decodedPhoto: PhotoResult, createdAt: Date?) {
        id = decodedPhoto.id
        size = CGSize(width: decodedPhoto.width, height: decodedPhoto.height)
        self.createdAt = createdAt
        welcomeDescription = decodedPhoto.description
        thumbImageURL = decodedPhoto.urls.thumb
        largeImageURL = decodedPhoto.urls.full
        isLiked = decodedPhoto.isLiked
    }

    init(photo: Photo) {
        id = photo.id
        size = photo.size
        createdAt = photo.createdAt
        welcomeDescription = photo.welcomeDescription
        thumbImageURL = photo.thumbImageURL
        largeImageURL = photo.largeImageURL
        isLiked = !photo.isLiked
    }

    private let dateFormatter = ISO8601DateFormatter()
   

}
