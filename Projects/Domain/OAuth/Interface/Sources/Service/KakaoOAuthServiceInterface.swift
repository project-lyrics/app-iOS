//
//  KakaoOAuthServiceInterface.swift
//  OAuthInterface
//
//  Created by Inwoo Hwang on 5/25/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation
import KakaoSDKUser

final public class KakaoOAuthService {
    // MARK: - 추후 accessTokenKey와 refreshTokenKey는 숨겨야 합니다. 
    public let accessTokenKey: String = "FeelinAccessTokenKey"
    public let refreshTokenKey: String = "FeelinRefreshTokenKey"
    
    public let kakaoUserAPI: KakaoUserAPIProtocol
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    
    public init(
        kakaoUserAPI: KakaoUserAPIProtocol = UserApi.shared,
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageInterface
    ) {
        self.kakaoUserAPI = kakaoUserAPI
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
    }
}
