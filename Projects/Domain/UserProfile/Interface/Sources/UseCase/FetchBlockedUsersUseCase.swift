//
//  FetchBlockedUsersUseCase.swift
//  DomainUserProfileInterface
//
//  Created by 황인우 on 11/22/24.
//

import Core
import DomainSharedInterface

import Foundation
import Combine

public protocol FetchBlockedUsersUseCaseInterface {
    func execute() -> AnyPublisher<[User], UserProfileError>
}

public struct FetchBlockedUsersUseCase: FetchBlockedUsersUseCaseInterface {
    private let userProfileAPIService: UserProfileAPIServiceInterface
    
    public init(userProfileAPIService: UserProfileAPIServiceInterface) {
        self.userProfileAPIService = userProfileAPIService
    }
    
    public func execute() -> AnyPublisher<[User], UserProfileError> {
        return userProfileAPIService.fetchBlockedUsers()
            .map { $0.map(User.init) }
            .eraseToAnyPublisher()
    }
}
