//
//  AppleOAuthServiceInterface.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation

public class AppleLoginService: NSObject {
    // MARK: - 추후 accessTokenKey와 refreshTokenKey는 숨겨야 합니다.
    public let accessTokenKey: String = "FeelinAccessTokenKey"
    public let refreshTokenKey: String = "FeelinRefreshTokenKey"
    public var networkProvider: NetworkProviderInterface
    public var tokenStorage: TokenStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    public var appleTokenSubject: PassthroughSubject<String, AppleOAuthError> = .init()
    
    public init(
        networkProvider: NetworkProviderInterface,
        tokenStorage: TokenStorageInterface
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
    }
}
