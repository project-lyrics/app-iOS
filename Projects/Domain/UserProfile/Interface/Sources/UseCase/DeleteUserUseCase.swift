//
//  DeleteUserUseCase.swift
//  DomainUserProfileInterface
//
//  Created by Derrick kim on 10/12/24.
//

import Core

import Foundation
import Combine
import Shared

public protocol DeleteUserUseCaseInterface {
    func execute() -> AnyPublisher<FeelinDefaultResponse, UserProfileError>
}

public struct DeleteUserUseCase: DeleteUserUseCaseInterface {
    private let userProfileAPIService: UserProfileAPIServiceInterface
    private let tokenStorage: TokenStorageInterface

    public init(
        userProfileAPIService: UserProfileAPIServiceInterface,
        tokenStorage: TokenStorageInterface
    ) {
        self.userProfileAPIService = userProfileAPIService
        self.tokenStorage = tokenStorage
    }

    public func execute() -> AnyPublisher<FeelinDefaultResponse, UserProfileError> {
        return userProfileAPIService.deleteUser()
            .flatMap { response in
                return self.deleteTokens().map { _ in response }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func deleteTokens() -> AnyPublisher<Void, UserProfileError> {
        do {
            guard let accessTokenKey = Bundle.main.accessTokenKey,
                  let refreshTokenKey = Bundle.main.refreshTokenKey,
                  let userInfoKey = Bundle.main.userInfoKey else {
                return Fail(error: UserProfileError.bundleError(.missingItem(itemName: String(describing: self))))
                    .eraseToAnyPublisher()
            }

            try tokenStorage.delete(for: accessTokenKey)
            try tokenStorage.delete(for: refreshTokenKey)
            try tokenStorage.delete(for: userInfoKey)

            return Just(())
                .setFailureType(to: UserProfileError.self)
                .eraseToAnyPublisher()

        } catch let error as KeychainError {
            return Fail(error: .keychainError(error))
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknown(errorDescription: error.localizedDescription))
                .eraseToAnyPublisher()
        }
    }
}
