//
//  AppleOAuthServiceInterface.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation

public class AppleLoginService: NSObject {
    public var networkProvider: NetworkProviderInterface
    public var tokenStorage: TokenStorageInterface
    public let jwtDecoder: JWTDecoder = .init()
    public let tokenKeyHolder: TokenKeyHolderInterface
    public var appleTokenSubject: PassthroughSubject<String, AppleOAuthError> = .init()
    
    public init(
        networkProvider: NetworkProviderInterface,
        tokenStorage: TokenStorageInterface,
        tokenKeyHolder: TokenKeyHolderInterface = TokenKeyHolder()
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.tokenKeyHolder = tokenKeyHolder
    }
}
