import Foundation

private let accessKeyStandard = "8PVUoJyRFHtv1tJQB0FQCzT5JCiEF2zZ304TsjbxsbM"
private let secretKeyStandard = "weKhhVpSHuSQRiBustHClJ1Kc55O6Yc1NDwitbmJCX8"
private let redirectURIStandard = "urn:ietf:wg:oauth:2.0:oob"
private let accessScopeStandard = "public+read_user+write_likes"
private let defaultBaseURLStandard = URL(string: "https://api.unsplash.com")!
private let unsplashAuthorizeURLStringStandard = "https://unsplash.com/oauth/authorize"
private let unsplashTokenURLStringStandard = "https://unsplash.com/oauth/token"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    let unsplashTokenURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: accessKeyStandard,
            secretKey: secretKeyStandard,
            redirectURI: redirectURIStandard,
            accessScope: accessScopeStandard,
            defaultBaseURL: defaultBaseURLStandard,
            unsplashAuthorizeURLString: unsplashAuthorizeURLStringStandard,
            unsplashTokenURLString: unsplashTokenURLStringStandard
        )
    }

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashAuthorizeURLString: String, unsplashTokenURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashTokenURLString = unsplashTokenURLString
    }

}
