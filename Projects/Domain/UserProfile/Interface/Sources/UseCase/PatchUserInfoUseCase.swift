//
//  patchUserProfileUseCase.swift
//  DomainUserProfile
//
//  Created by Derrick kim on 10/10/24.
//

import Core

import Foundation
import Combine

public protocol PatchUserProfileUseCaseInterface {
    func execute(requestValue: UserProfileRequestValue) -> AnyPublisher<FeelinSuccessResponse, UserProfileError>
}

public struct patchUserProfileUseCase: PatchUserProfileUseCaseInterface {

    private let userProfileAPIService: UserProfileAPIServiceInterface

    public init(userProfileAPIService: UserProfileAPIServiceInterface) {
        self.userProfileAPIService = userProfileAPIService
    }

    public func execute(requestValue: UserProfileRequestValue) -> AnyPublisher<FeelinSuccessResponse, UserProfileError> {
        return userProfileAPIService.patchUserProfile(requestValue: requestValue)
            .eraseToAnyPublisher()
    }
}
