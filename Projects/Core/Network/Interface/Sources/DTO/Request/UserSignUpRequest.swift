//
//  UserSignUpRequest.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 7/6/24.
//

import Foundation

// MARK: - UserSignUpRequest

public struct UserSignUpRequest: Encodable {
    let socialAccessToken: String
    let authProvider: String
    let nickname: String
    let profileCharacter: String
    let gender: String?
    let birthYear: String?
    let terms: [Term]
    let isAdmin: Bool

    public init(
        socialAccessToken: String,
        authProvider: String,
        nickname: String,
        profileCharacter: String,
        gender: String? = nil,
        birthYear: String? = nil,
        terms: [Term],
        isAdmin: Bool
    ) {
        self.socialAccessToken = socialAccessToken
        self.authProvider = authProvider
        self.nickname = nickname
        self.profileCharacter = profileCharacter
        self.gender = gender
        self.birthYear = birthYear
        self.terms = terms
        self.isAdmin = isAdmin
    }
}

// MARK: - OAuthProvider

public enum OAuthProvider: String, Encodable {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

// MARK: - Gender

public enum Gender: String, Encodable {
    case male = "MALE"
    case female = "FEMALE"
}

// MARK: - Term

public struct Term: Encodable {
    let agree: Bool
    let title: String
    let agreement: String

    public init(agree: Bool, title: String, agreement: String) {
        self.agree = agree
        self.title = title
        self.agreement = agreement
    }
}
