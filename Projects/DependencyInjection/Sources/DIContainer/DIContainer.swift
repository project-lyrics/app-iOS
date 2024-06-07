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

extension DIContainer {
    public static func registerNormalNetwork() {
        standard.register(.networkProvider) { resolver in
            let networkSession = NetworkSession(
                urlSession: URLSession.shared,
                requestInterceptor: nil
            )
            return NetworkProvider(networkSession: networkSession)
        }
    }
    
    public static func registerTokenStorageNetwork() {
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

    public static func registerKakaoOAuthService() {
        standard.register(.kakaoOAuthService) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let networkProvider = try resolver.resolve(.networkProvider)
            return KakaoOAuthService(networkProvider: networkProvider, tokenStorage: tokenStorage)
        }
    }

    public static func registerUserValidityService() {
        standard.register(.userValidityService) { resolver in
            let tokenStorage = try resolver.resolve(.tokenStorage)
            let networkProvider = try resolver.resolve(.networkProvider)
            return UserValidityService(networkProvider: networkProvider, tokenStorage: tokenStorage)
        }
    }
}
