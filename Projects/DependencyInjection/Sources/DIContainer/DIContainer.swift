//
//  DIContainer.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/17/24.
//

import Core
import Domain

import Foundation

public final class DIContainer: Injectable {
    public var dependencies: [AnyHashable : Any] = [:]
    public static let standard = DIContainer()
    public required init() { }
}

// MARK: Network
public extension DIContainer {
    static func registerNetworkProvider(hasTokenStorage: Bool = false) {
        if hasTokenStorage {
            standard.register(.tokenStorage) { _ in return TokenStorage() }
        }

        standard.register(.networkProvider) { resolver in
            var requestInterceptor: TokenInterceptor?

            if hasTokenStorage {
                let tokenStorage = try resolver.resolve(.tokenStorage)
                requestInterceptor = TokenInterceptor(tokenStorage: tokenStorage)
            }

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
            let recentLoginRecordService = try resolver.resolve(.recentLoginRecordService)

            return KakaoOAuthService(
                networkProvider: networkProvider,
                tokenStorage: tokenStorage, 
                recentLoginRecordService: recentLoginRecordService
            )
        }
    }

    static func registerAppleOAuthService() {
        standard.register(.appleOAuthService) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let networkProvider = try resolver.resolve(.networkProvider)
            let recentLoginRecordService = try resolver.resolve(.recentLoginRecordService)

            return AppleLoginService(
                networkProvider: networkProvider,
                tokenStorage: tokenStorage,
                recentLoginRecordService: recentLoginRecordService
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
    
    static func registerDependenciesForArtistSelectView() {
        standard.register(.artistPaginationService) { _ in
            return ArtistPaginationService()
        }
        
        standard.register(.artistAPIService) { resolver in
            let networkProvider = try resolver.resolve(.networkProvider)
            return ArtistAPIService(networkProvider: networkProvider)
        }
    }
}
