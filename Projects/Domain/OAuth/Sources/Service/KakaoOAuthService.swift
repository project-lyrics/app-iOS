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

extension KakaoOAuthService: OAuthServiceInterface, UserVerifiable {
    public func login() -> AnyPublisher<OAuthResult, AuthError> {
        return fetchKakaoAccessToken()
            .map { ($0, OAuthProvider.kakao) }
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
                    if let sdkError = error as? KakaoOAuthError {
                        promise(.failure(.kakaoOAuthError(sdkError)))
                    } else {
                        guard let accessToken = oAuthToken?.accessToken else {
                            promise(
                                .failure(.kakaoOAuthError(.init(apiFailedMessage: "AccessToken이 nil입니다.")))
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
                    if let sdkError = error as? KakaoOAuthError {
                        promise(.failure(.kakaoOAuthError(sdkError)))
                    } else {
                        guard let accessToken = oAuthToken?.accessToken else {
                            promise(
                                .failure(.kakaoOAuthError(.init(apiFailedMessage: "AccessToken이 nil입니다.")))
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
