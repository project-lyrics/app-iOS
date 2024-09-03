//
//  SignUpServiceInterface.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/9/24.
//

import Combine
import Core

public protocol SignUpServiceInterface {
    func signUp(
        _ entity: UserSignUpEntity
    ) -> AnyPublisher<SignUpResult, SignUpError>
}

public final class SignUpService {
    public let networkProvider: NetworkProviderInterface
    public let tokenStorage: TokenStorageInterface
    public let userInfoStorage: UserInfoStorageInterface
    public let tokenKeyHolder: TokenKeyHolderInterface
    public let jwtDecoder: JWTDecoder = .init()

    public init(
        networkProvider: NetworkProviderInterface,
        tokenStorage: TokenStorageInterface,
        userInfoStorage: UserInfoStorageInterface,
        tokenKeyHolder: TokenKeyHolderInterface = TokenKeyHolder()
    ) {
        self.networkProvider = networkProvider
        self.tokenStorage = tokenStorage
        self.userInfoStorage = userInfoStorage
        self.tokenKeyHolder = tokenKeyHolder
    }
}
