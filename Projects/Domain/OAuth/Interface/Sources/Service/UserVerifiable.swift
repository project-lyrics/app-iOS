//
//  UserVerifiable.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import CoreNetworkInterface
import CoreLocalStorageInterface
import Foundation

public protocol UserVerifiable {
    // MARK: - 추후 accessTokenKey와 refreshTokenKey는 숨겨야 합니다.
    var accessTokenKey: String { get }
    var refreshTokenKey: String { get }
    var networkProvider: NetworkProviderInterface { get }
    var tokenStorage: TokenStorageInterface { get }
    var jwtDecoder: JWTDecoder { get }
    
    func verifyUser(
        oAuthToken: String,
        oAuthProvider: OAuthProvider
    ) -> AnyPublisher<OAuthResult, AuthError>
}
