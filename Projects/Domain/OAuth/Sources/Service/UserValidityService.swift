//
//  UserValidityService.swift
//  DomainOAuth
//
//  Created by 황인우 on 5/30/24.
//

import Combine
import Core
import Foundation
import CoreNetworkInterface
import DomainOAuthInterface

extension UserValidityService: UserValidityServiceInterface {
    public func isUserValid() -> AnyPublisher<Bool, AuthError> {
        guard let accessTokenKey = try? tokenKeyHolder.fetchAccessTokenKey(),
              let accessToken: AccessToken = try? tokenStorage.read(key: accessTokenKey) else {
            return Fail(error: AuthError.keychainError(.itemNotFound)).eraseToAnyPublisher()
        }

        let endpoint: FeelinAPI<UserValidityResponse> = FeelinAPI.checkUserValidity(accessToken: accessToken.token)

        return networkProvider
            .request(endpoint)
            .map(\.data.isValid)
            .mapError { error in
                AuthError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
}
