//
//  CheckFirstVisitorUseCase.swift
//  DomainUserProfileInterface
//
//  Created by Derrick kim on 10/20/24.
//

import Core

import Foundation
import Combine
import Shared

public protocol CheckFirstVisitorUseCaseInterface {
    func execute() -> AnyPublisher<Bool, UserProfileError>
}

public struct CheckFirstVisitorUseCase: CheckFirstVisitorUseCaseInterface {
    private let userProfileAPIService: UserProfileAPIServiceInterface

    public init(userProfileAPIService: UserProfileAPIServiceInterface) {
        self.userProfileAPIService = userProfileAPIService
    }

    public func execute() -> AnyPublisher<Bool, UserProfileError> {
        return userProfileAPIService.checkFirstVisitor()
            .map(\.isFirst)
            .eraseToAnyPublisher()
    }
}
