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
    let authProvider: OAuthProvider
    let nickname: String
    let profileCharacter: String
    let gender: Gender
    let birthYear: String
    let terms: [Term]

    public init(
        socialAccessToken: String,
        authProvider: OAuthProvider,
        nickname: String,
        profileCharacter: String,
        gender: Gender,
        birthYear: String,
        terms: [Term]
    ) {
        self.socialAccessToken = socialAccessToken
        self.authProvider = authProvider
        self.nickname = nickname
        self.profileCharacter = profileCharacter
        self.gender = gender
        self.birthYear = birthYear
        self.terms = terms
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

// MARK: - UserSignUpRequest

public struct UserSignUpRequest: Encodable {
    let socialAccessToken: String
    let authProvider: OAuthProvider
    let username: String
    let gender: Gender
    let birthYear: String
    let terms: [Term]

    public init(
        socialAccessToken: String,
        authProvider: OAuthProvider,
        username: String,
        gender: Gender,
        birthYear: String,
        terms: [Term]
    ) {
        self.socialAccessToken = socialAccessToken
        self.authProvider = authProvider
        self.username = username
        self.gender = gender
        self.birthYear = birthYear
        self.terms = terms
    }
}
