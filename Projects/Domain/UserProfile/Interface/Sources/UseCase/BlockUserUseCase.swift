//
//  BlockUserUseCase.swift
//  DomainUserProfileInterface
//
//  Created by 황인우 on 11/22/24.
//

import Core

import Foundation
import Combine

public protocol BlockUserUseCaseInterface {
    func execute(
        shouldBlock: Bool,
        userID: Int
    ) -> AnyPublisher<Bool, UserProfileError>
}


public struct BlockUserUseCase: BlockUserUseCaseInterface {
    private let userProfileAPIService: UserProfileAPIServiceInterface
    
    public init(
        userProfileAPIService: UserProfileAPIServiceInterface
    ) {
        self.userProfileAPIService = userProfileAPIService
    }
    
    public func execute(
        shouldBlock: Bool,
        userID: Int
    ) -> AnyPublisher<Bool, UserProfileError> {
        if shouldBlock {
            return userProfileAPIService.postBlockUserProfile(userID: userID)
                .map(\.success)
                .eraseToAnyPublisher()
        } else {
            return userProfileAPIService.deleteBlockUserProfile(userID: userID)
                .map(\.success)
                .eraseToAnyPublisher()
        }
    }
}
