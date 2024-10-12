//
//  GetUserProfileUseCase.swift
//  DomainUserProfile
//
//  Created by Derrick kim on 10/10/24.
//

import Core

import Foundation
import Combine

public protocol GetUserProfileUseCaseInterface {
    func execute() -> AnyPublisher<UserProfile, UserProfileError>
}

public struct GetUserProfileUseCase: GetUserProfileUseCaseInterface {
    private let userProfileAPIService: UserProfileAPIServiceInterface

    public init(userProfileAPIService: UserProfileAPIServiceInterface) {
        self.userProfileAPIService = userProfileAPIService
    }

    public func execute() -> AnyPublisher<UserProfile, UserProfileError> {
        return userProfileAPIService.getUserProfile()
            .receive(on: DispatchQueue.main)
            .map(UserProfile.init)
            .eraseToAnyPublisher()
    }
}
