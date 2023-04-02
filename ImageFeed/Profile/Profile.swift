import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(username: String, name: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = "@\(username)"
        self.bio = bio
    }
}
