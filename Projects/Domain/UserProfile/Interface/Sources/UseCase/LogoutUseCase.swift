//
//  LogoutUseCase.swift
//  DomainUserProfileInterface
//
//  Created by 황인우 on 10/13/24.
//

import Core
import Shared

import Combine
import Foundation


public protocol LogoutUseCaseInterface {
    func execute() -> AnyPublisher<Result<Void, UserProfileError>, Never>
}

public struct LogoutUseCase: LogoutUseCaseInterface {
    private let tokenStorage: TokenStorageInterface
    
    public init(tokenStorage: TokenStorageInterface) {
        self.tokenStorage = tokenStorage
    }
    
    public func execute() -> AnyPublisher<Result<Void, UserProfileError>, Never> {
        do {
            guard let accessTokenKey = Bundle.main.accessTokenKey,
                  let refreshTokenKey = Bundle.main.refreshTokenKey,
                  let userInfoKey = Bundle.main.userInfoKey else {
                return Just(
                    .failure(.bundleError(.missingItem(itemName: String(describing: self))))
                )
                .eraseToAnyPublisher()
            }
            
            try tokenStorage.delete(for: accessTokenKey)
            try tokenStorage.delete(for: refreshTokenKey)
            try tokenStorage.delete(for: userInfoKey)
            
            return Just(.success(()))
                .eraseToAnyPublisher()
        } catch let error as KeychainError {
            return Just(.failure(.keychainError(error)))
                .eraseToAnyPublisher()
        } catch {
            return Just(.failure(.unknown(errorDescription: error.localizedDescription)))
                .eraseToAnyPublisher()
        }
    }
}
