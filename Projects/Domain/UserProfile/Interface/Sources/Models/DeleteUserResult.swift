//
//  DeleteUserResult.swift
//  DomainUserProfileInterface
//
//  Created by 황인우 on 10/21/24.
//

import Foundation

public enum DeleteUserResult: Equatable {
    case none
    case success
    case failure(UserProfileError)
}
