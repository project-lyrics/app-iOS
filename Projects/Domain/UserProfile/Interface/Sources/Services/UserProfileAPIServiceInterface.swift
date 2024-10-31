//
//  UserProfileAPIServiceInterface.swift
//  DomainUserProfileInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Core

import Combine
import Foundation

public protocol UserProfileAPIServiceInterface {
    func getUserProfile() -> AnyPublisher<UserProfileResponse, UserProfileError>
    func patchUserProfile(requestValue: UserProfileRequestValue) -> AnyPublisher<FeelinSuccessResponse, UserProfileError>
    func deleteUser() -> AnyPublisher<FeelinDefaultResponse, UserProfileError>
    func checkFirstVisitor() -> AnyPublisher<FirstVisitorResponse, UserProfileError>
}
