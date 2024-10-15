//
//  UserProfile.swift
//  DomainUserProfile
//
//  Created by Derrick kim on 10/10/24.
//

import Shared

import Foundation
import DomainOAuthInterface
import Core

public struct UserProfile {
    public let id: Int
    public let nickname: String
    public let profileCharacterType: ProfileCharacterType
    public var gender: GenderEntity?
    public var birthYear: Int?
    public let feedbackID: String
    public let authProvider: String

    public init(
        id: Int,
        nickname: String,
        profileCharacterType: ProfileCharacterType,
        gender: GenderEntity?,
        birthYear: Int?,
        feedbackID: String,
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
        self.gender = GenderEntity(rawValue: dto.gender ?? "") ?? .male
        self.birthYear = dto.birthYear
        self.feedbackID = dto.feedbackID
        self.authProvider = dto.authProvider
    }
}

public extension UserProfile {
    static let mockData = UserProfile(
        id: 674,
        nickname: "nickname",
        profileCharacterType: ProfileCharacterType.braidedHair,
        gender: .female,
        birthYear: 1999,
        feedbackID: "b7524f67-63fc-4beb-9d5d-13557a542244",
        authProvider: "KAKAO"
    )
}
