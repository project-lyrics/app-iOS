//
//  TokenInterceptor.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/27/24.
//

import Combine
import CoreLocalStorageInterface
import Foundation

import Shared

final public class TokenInterceptor {
    public let tokenStorage: TokenStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    public let tokenKeyHolder: TokenKeyHolderInterface
    
    public init(
        tokenStorage: TokenStorageInterface,
        tokenKeyHolder: TokenKeyHolderInterface = TokenKeyHolder()
    ) {
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
    }
}
