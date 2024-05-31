//
//  UserValidityServiceInterface.swift
//  DomainOAuth
//
//  Created by 황인우 on 5/30/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation

public protocol UserValidityServiceInterface {
    func isUserValid() -> AnyPublisher<Bool, AuthError>
}

final public class UserValidityService {
    // MARK: - 추후 accessTokenKey와 refreshTokenKey는 숨겨야 합니다.
    public let accessTokenKey: String = "FeelinAccessTokenKey"
    public let refreshTokenKey: String = "FeelinRefreshTokenKey"
    public let networkProvider: NetworkProviderProtocol
    public let tokenStorage: TokenStorageInterface
    
    public init(
        networkProvider: NetworkProviderProtocol,
        tokenStorage: TokenStorageInterface
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
    }
}
