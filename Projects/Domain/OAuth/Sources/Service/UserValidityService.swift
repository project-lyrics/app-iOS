//
//  UserValidityService.swift
//  DomainOAuth
//
//  Created by 황인우 on 5/30/24.
//

import Combine
import Foundation
import CoreNetworkInterface
import DomainOAuthInterface

extension UserValidityService: UserValidityServiceInterface {
    public func isUserValid() -> AnyPublisher<Bool, AuthError> {
        let endpoint: FeelinAPI<UserValidityResponse> = FeelinAPI.checkUserValidity
        return networkProvider
            .request(endpoint)
            .map(\.data.isValid)
            .mapError(AuthError.networkError)
            .eraseToAnyPublisher()
    }
}
