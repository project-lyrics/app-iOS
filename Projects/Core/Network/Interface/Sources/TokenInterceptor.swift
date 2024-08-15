//
//  TokenInterceptor.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/27/24.
//

import Combine
import CoreLocalStorageInterface
import Foundation

final public class TokenInterceptor {
    // MARK: - 추후 accessTokenKey와 refreshTokenKey는 숨겨야 합니다.
    public let accessTokenKey: String = "FeelinGoodAccessRight"
    public let refreshTokenKey: String = "FeelinGoodRefreshRight"
    public let tokenStorage: TokenStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    
    public init(tokenStorage: TokenStorageInterface) {
        self.tokenStorage = tokenStorage
    }
}
