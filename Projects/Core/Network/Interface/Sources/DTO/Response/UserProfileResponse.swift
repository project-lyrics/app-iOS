//
//  UserProfileResponse.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation

public struct UserProfileResponse: Decodable {
    public let id: Int
    public let nickname: String
    public let profileCharacterType: String
    public let gender: String?
    public let birthYear: Int?
    public let feedbackID: String
    public let authProvider: String

    public init(
        id: Int,
        nickname: String,
        profileCharacterType: String,
        gender: String?,
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

    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case profileCharacterType
        case gender
        case birthYear
        case feedbackID = "feedbackId"
        case authProvider
    }
}
