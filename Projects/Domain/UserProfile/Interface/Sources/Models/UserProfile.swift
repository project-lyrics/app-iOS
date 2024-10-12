//
//  UserProfile.swift
//  DomainUserProfile
//
//  Created by Derrick kim on 10/10/24.
//

import Core
import Shared

import Foundation

public struct UserProfile {
    public let id: Int
    public let nickname: String
    public let profileCharacterType: ProfileCharacterType
    public let gender: Gender
    public let birthYear: Int
    public let feedbackID: String?
    public let authProvider: String

    public init(
        id: Int,
        nickname: String,
        profileCharacterType: ProfileCharacterType,
        gender: Gender,
        birthYear: Int,
        feedbackID: String?,
        authProvider: String
    ) {
        self.id = id
        self.nickname = nickname
        self.profileCharacterType = profileCharacterType
        self.gender = gender
        self.birthYear = birthYear
        self.feedbackID = feedbackID
        self.authProvider = authProvider
    }

    public init(dto: UserProfileResponse) {
        self.id = dto.id
        self.nickname = dto.nickname
        self.profileCharacterType = ProfileCharacterType(rawValue: dto.profileCharacterType) ?? .braidedHair
        self.gender = Gender(rawValue: dto.gender) ?? .male
        self.birthYear = dto.birthYear
        self.feedbackID = dto.feedbackID
        self.authProvider = dto.authProvider
    }
}
