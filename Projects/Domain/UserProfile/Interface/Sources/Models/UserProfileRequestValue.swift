//
//  UserProfileRequestValue.swift
//  DomainUserProfile
//
//  Created by Derrick kim on 10/10/24.
//

import Core
import Shared

import Foundation

public struct UserProfileRequestValue {
    public let nickname: String
    public let profileCharacter: ProfileCharacterType

    public init(
        nickname: String,
        profileCharacter: ProfileCharacterType
    ) {
        self.nickname = nickname
        self.profileCharacter = profileCharacter
    }

    public func toDTO() -> UserProfileRequest {
        return UserProfileRequest(
            nickname: nickname,
            profileCharacter: profileCharacter.rawValue
        )
    }
}
