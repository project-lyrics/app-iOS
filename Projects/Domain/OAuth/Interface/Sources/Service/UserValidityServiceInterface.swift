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
    public let networkProvider: NetworkProviderInterface
    public let tokenStorage: TokenStorageInterface
    
    public init(
        networkProvider: NetworkProviderInterface,
        tokenStorage: TokenStorageInterface
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
    }
}
