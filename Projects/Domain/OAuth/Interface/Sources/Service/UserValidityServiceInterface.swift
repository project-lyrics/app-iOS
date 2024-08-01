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
    func isUserValid() -> AnyPublisher<Void, AuthError>
}

final public class UserValidityService {
    public let networkProvider: NetworkProviderInterface
    public let tokenStorage: TokenStorageInterface
    public let tokenKeyHolder: TokenKeyHolderInterface

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
