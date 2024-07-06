//
//  UserSignUpRequest.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 7/6/24.
//

import Foundation

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
}

// MARK: - UserSignUpRequest

public struct UserSignUpRequest: Encodable {
    let socialAccessToken: String
    let authProvider: OAuthProvider
    let username: String
    let gender: Gender
    let birthYear: String
    let terms: [Term]
}
