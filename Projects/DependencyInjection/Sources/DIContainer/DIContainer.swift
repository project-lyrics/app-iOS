//
//  DIContainer.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/17/24.
//

import Foundation
import CoreNetwork
import CoreNetworkInterface
import CoreLocalStorage
import DomainOAuthInterface
import DomainOAuth

public final class DIContainer: Injectable {
    public var dependencies: [AnyHashable : Any] = [:]
    public static let standard = DIContainer()
    public required init() { }
}

// MARK: Network
public extension DIContainer {
    static func registerNormalNetwork() {
        standard.register(.networkProvider) { resolver in
            let networkSession = NetworkSession(
                urlSession: URLSession.shared,
                requestInterceptor: nil
            )
            return NetworkProvider(networkSession: networkSession)
        }
    }
    
    static func registerTokenStorageNetwork() {
        standard.register(.tokenStorage) { _ in return TokenStorage() }
        standard.register(.networkProvider) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let requestInterceptor = TokenInterceptor(tokenStorage: tokenStorage)
            let networkSession = NetworkSession(
                urlSession: URLSession.shared,
                requestInterceptor: requestInterceptor
            )
            return NetworkProvider(networkSession: networkSession)
        }
    }
}

// MARK: Login
public extension DIContainer {
    static func registerKakaoOAuthService() {
        standard.register(.kakaoOAuthService) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let networkProvider = try resolver.resolve(.networkProvider)
            return KakaoOAuthService(
                networkProvider: networkProvider,
                tokenStorage: tokenStorage
            )
        }
    }

    static func registerAppleOAuthService() {
        standard.register(.appleOAuthService) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let networkProvider = try resolver.resolve(.networkProvider)
            return AppleLoginService(
                networkProvider: networkProvider,
                tokenStorage: tokenStorage
            )
        }
    }

    static func registerUserValidityService() {
        standard.register(.userValidityService) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let networkProvider = try resolver.resolve(.networkProvider)
            return UserValidityService(networkProvider: networkProvider, tokenStorage: tokenStorage)
        }
    }

    static func registerRecentLoginRecordService() {
        standard.register(.recentLoginRecordStorage) { _ in return RecentLoginRecordStorage() }
        standard.register(.recentLoginRecordService) { resolver in
            let recentLoginRecordStorage = try resolver.resolve(.recentLoginRecordStorage)
            return RecentLoginRecordService(recentLocalStorage: recentLoginRecordStorage)
        }
    }
}
