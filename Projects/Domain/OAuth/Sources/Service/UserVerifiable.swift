//
//  UserVerifiable.swift
//  DomainOAuth
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import CoreNetworkInterface
import CoreLocalStorageInterface
import DomainOAuthInterface
import Foundation

extension UserVerifiable {
    public func verifyUser(
        oAuthToken: String,
        oAuthProvider: OAuthProvider
    ) -> AnyPublisher<OAuthResult, AuthError> {
        let endpoint = FeelinAPI<UserLoginResponse>.login(
            oauthProvider: oAuthProvider,
            oauthAccessToken: oAuthToken
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
                case let error as KakaoOAuthError:
                    return AuthError.kakaoOAuthError(error)

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
