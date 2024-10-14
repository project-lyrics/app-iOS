//
//  UserVerifiable.swift
//  DomainOAuth
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import Foundation

import Core
import DomainOAuthInterface
import Shared

extension UserVerifiable {
    public func verifyUser(
        oAuthToken: String,
        oAuthProvider: OAuthProvider
    ) -> AnyPublisher<OAuthResult, AuthError> {
        let endpoint = FeelinAPI<UserAuthResponse>.login(
            oAuthProvider: oAuthProvider,
            oAuthAccessToken: oAuthToken
        )

        let type = OAuthType(rawValue: oAuthProvider.rawValue) ?? .none

        return networkProvider.request(endpoint)
            .tryMap { [jwtDecoder] response -> (AccessToken, RefreshToken, UserID: Int) in
                return (
                    try jwtDecoder.decode(response.accessToken, as: AccessToken.self),
                    try jwtDecoder.decode(response.refreshToken, as: RefreshToken.self),
                    response.userId
                )
            }
            .tryMap { [tokenStorage, tokenKeyHolder, userInfoStorage, recentLoginRecordService] (accessToken, refreshToken, userID) in
                let accessTokenKey = try tokenKeyHolder.fetchAccessTokenKey()
                let refreshTokenKey = try tokenKeyHolder.fetchRefreshTokenKey()

                try tokenStorage.save(token: accessToken, for: accessTokenKey)
                try tokenStorage.save(token: refreshToken, for: refreshTokenKey)
                try userInfoStorage.save(userInformation: .init(userID: userID))
                
                recentLoginRecordService.save(oAuthType: type.rawValue)
            }
            .map { _ in
                return OAuthResult.success(type)
            }
            .mapError({ error in
                switch error {
                case let error as KakaoOAuthError:
                    return AuthError.kakaoOAuthError(error)

                case let error as KeychainError:
                    return AuthError.keychainError(error)

                case let error as NetworkError:
                    switch error {
                    case .feelinAPIError(.userDataNotFound(_,_)):
                        return AuthError.feelinError(.userNotFound((accessToken: oAuthToken, oAuthType: type)))

                    default:
                        return AuthError.networkError(error)
                    }

                case let error as JWTError:
                    return AuthError.jwtParsingError(error)

                default:
                    return AuthError.unExpectedError(error)
                }
            })
            .eraseToAnyPublisher()
    }
}
