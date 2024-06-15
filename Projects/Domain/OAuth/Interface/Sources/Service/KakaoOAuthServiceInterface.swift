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
    public let kakaoUserAPI: KakaoUserAPIProtocol
    public let networkProvider: NetworkProviderInterface
    public let tokenStorage: TokenStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    public let tokenKeyHolder: TokenKeyHolderInterface
    
    public init(
        kakaoUserAPI: KakaoUserAPIProtocol = UserApi.shared,
        networkProvider: NetworkProviderInterface,
        tokenStorage: TokenStorageInterface,
        tokenKeyHolder: TokenKeyHolderInterface = TokenKeyHolder()
    ) {
        self.kakaoUserAPI = kakaoUserAPI
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
    }
}
