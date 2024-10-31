//
//  UserProfileAPIService.swift
//  DomainUserProfileInterface
//
//  Created by Derrick kim on 10/10/24.
//
import Core
import DomainUserProfileInterface

import Combine
import Foundation

public struct UserProfileAPIService: UserProfileAPIServiceInterface {
    
    private let networkProvider: NetworkProviderInterface

    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }

    public func getUserProfile() -> AnyPublisher<UserProfileResponse, UserProfileError> {
        let endpoint = FeelinAPI<UserProfileResponse>.getUserProfile

        return networkProvider.request(endpoint)
            .mapError(UserProfileError.init)
            .eraseToAnyPublisher()
    }

    public func patchUserProfile(requestValue: UserProfileRequestValue) -> AnyPublisher<FeelinSuccessResponse, UserProfileError> {
        let request = requestValue.toDTO()
        let endpoint = FeelinAPI<FeelinSuccessResponse>.patchUserProfile(request: request)

        return networkProvider.request(endpoint)
            .mapError(UserProfileError.init)
            .eraseToAnyPublisher()
    }

    public func deleteUser() -> AnyPublisher<FeelinDefaultResponse, UserProfileError> {
        let endpoint = FeelinAPI<FeelinDefaultResponse>.deleteUser

        return networkProvider.request(endpoint)
            .mapError(UserProfileError.init)
            .eraseToAnyPublisher()
    }

    public func checkFirstVisitor() -> AnyPublisher<FirstVisitorResponse, UserProfileError> {
        let endpoint = FeelinAPI<FirstVisitorResponse>.checkFirstVisitor

        return networkProvider.request(endpoint)
            .mapError(UserProfileError.init)
            .eraseToAnyPublisher()
    }
}
