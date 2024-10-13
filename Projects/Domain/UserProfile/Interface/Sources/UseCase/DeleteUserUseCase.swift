//
//  DeleteUserUseCase.swift
//  DomainUserProfileInterface
//
//  Created by Derrick kim on 10/12/24.
//

import Core

import Foundation
import Combine

public protocol DeleteUserUseCaseInterface {
    func execute() -> AnyPublisher<FeelinSuccessResponse, UserProfileError>
}

public struct DeleteUserUseCase: DeleteUserUseCaseInterface {
    private let userProfileAPIService: UserProfileAPIServiceInterface

    public init(userProfileAPIService: UserProfileAPIServiceInterface) {
        self.userProfileAPIService = userProfileAPIService
    }

    public func execute() -> AnyPublisher<FeelinSuccessResponse, UserProfileError> {
        return userProfileAPIService.deleteUser()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
