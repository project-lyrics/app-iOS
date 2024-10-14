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
    var networkProvider: NetworkProviderInterface { get }
    var tokenStorage: TokenStorageInterface { get }
    var userInfoStorage: UserInfoStorageInterface { get }
    var jwtDecoder: JWTDecoder { get }
    var tokenKeyHolder: TokenKeyHolderInterface { get }
    var recentLoginRecordService: RecentLoginRecordServiceInterface { get }
  
    func verifyUser(
        oAuthToken: String,
        oAuthProvider: OAuthProvider
    ) -> AnyPublisher<OAuthResult, AuthError>
}
