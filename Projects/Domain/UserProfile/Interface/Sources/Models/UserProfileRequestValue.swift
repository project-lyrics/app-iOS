//
//  UserProfileRequestValue.swift
//  DomainUserProfile
//
//  Created by Derrick kim on 10/10/24.
//

import Core
import Shared

import Foundation
import DomainOAuthInterface

public struct UserProfileRequestValue {
    public let nickname: String
    public let profileCharacter: ProfileCharacterType
    public var gender: GenderEntity?
    public var birthYear: Int?

    public init(
        nickname: String,
        profileCharacter: ProfileCharacterType,
        gender: GenderEntity?,
        birthYear: Int?
    ) {
        self.nickname = nickname
        self.profileCharacter = profileCharacter
        self.gender = gender
        self.birthYear = birthYear
    }

    public func toDTO() -> UserProfileRequest {
        return UserProfileRequest(
            nickname: nickname,
            profileCharacter: profileCharacter.rawValue,
            gender: gender?.toDTO,
            birthYear: birthYear
        )
    }
}
