//
//  KakaoOAuthService.swift
//  DomainOAuth
//
//  Created by 황인우 on 5/25/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import DomainOAuthInterface
import Foundation
import KakaoSDKCommon
import KakaoSDKUser

extension KakaoOAuthService: KakaoOAuthServiceInterface {
    public func login() -> AnyPublisher<OAuthResult, AuthError> {
        return fetchKakaoAccessToken()
            .flatMap(verifyUser)
            .eraseToAnyPublisher()
    }
}

// MARK: - Kakao OAuth
private extension KakaoOAuthService {
    func fetchKakaoAccessToken() -> AnyPublisher<String, AuthError> {
        return Future { [kakaoUserAPI] promise in
            if UserApi.isKakaoTalkLoginAvailable() {
                kakaoUserAPI.loginWithKakaoTalk(
                    launchMethod: LaunchMethod.UniversalLink,
                    channelPublicIds: nil,
                    serviceTerms: nil,
                    nonce: nil
                ) { oAuthToken, error in
                    if let sdkError = error as? KakaoSDKError {
                        promise(.failure(.kakaoSdkError(sdkError)))
                    } else {
                        guard let accessToken = oAuthToken?.accessToken else {
                            promise(
                                .failure(.kakaoSdkError(.init(apiFailedMessage: "AccessToken이 nil입니다.")))
                            )
                            return
                        }
                        promise(.success(accessToken))
                    }
                }
            } else {
                kakaoUserAPI.loginWithKakaoAccount(
                    prompts: nil,
                    channelPublicIds: nil,
                    serviceTerms: nil,
                    nonce: nil
                ) { oAuthToken, error in
                    if let sdkError = error as? KakaoSDKError {
                        promise(.failure(.kakaoSdkError(sdkError)))
                    } else {
                        guard let accessToken = oAuthToken?.accessToken else {
                            promise(
                                .failure(.kakaoSdkError(.init(apiFailedMessage: "AccessToken이 nil입니다.")))
                            )
                            return
                        }
                        promise(.success(accessToken))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Verify User
private extension KakaoOAuthService {
    func verifyUser(kakaoAccessToken: String) -> AnyPublisher<OAuthResult, AuthError> {
        let endpoint = FeelinAPI<UserLoginResponse>.login(
            oauthProvider: .kakao, 
            oauthAccessToken: kakaoAccessToken
        )
        return networkProvider.request(endpoint)
            .tryMap { [jwtDecoder] response -> (AccessToken, RefreshToken) in
                return (
                    try jwtDecoder.decode(response.data.accessToken, as: AccessToken.self),
                    try jwtDecoder.decode(response.data.refreshToken, as: RefreshToken.self)
                )
            }
            .tryMap { [tokenStorage, accessTokenKey, refreshTokenKey] (accessToken, refreshToken) in
                try tokenStorage.save(token: accessToken, for: accessTokenKey)
                try tokenStorage.save(token: refreshToken, for: refreshTokenKey)
            }
            .map { _ in
                return OAuthResult(oAuthType: .kakaoLogin)
            }
            .mapError({ error in
                switch error {
                case let error as KakaoSDKError:
                    return AuthError.kakaoSdkError(error)
                    
                case let error as KeychainError:
                    return AuthError.keychainError(error)
                    
                case let error as NetworkError:
                    return AuthError.networkError(error)
                    
                case let error as JWTError:
                    return AuthError.jwtParsingError(error)
                default:
                    return AuthError.unidentifiedError(error)
                }
            })
            .eraseToAnyPublisher()
    }
}
