//
//  UserSignUpEntity.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/7/24.
//

import Core

public struct UserSignUpEntity {
    public var socialAccessToken: String?
    public var oAuthType: OAuthType?
    public var nickname: String?
    public var profileCharacter: String?
    public var gender: GenderEntity?
    public var birthYear: String?
    public var terms: [Term]

    public init(
        socialAccessToken: String? = nil,
        oAuthType: OAuthType? = nil,
        nickname: String? = nil,
        profileCharacter: String? = nil,
        gender: GenderEntity? = nil,
        birthYear: String? = nil,
        terms: [Term] = []
    ) {
        self.socialAccessToken = socialAccessToken
        self.oAuthType = oAuthType
        self.nickname = nickname
        self.profileCharacter = profileCharacter
        self.gender = gender
        self.birthYear = birthYear
        self.terms = terms
    }

    public func toDTO() -> UserSignUpRequest? {
        guard let socialAccessToken = socialAccessToken,
              let oAuthType = oAuthType?.rawValue,
              let authProvider = OAuthProvider(rawValue: oAuthType),
              let nickname = nickname,
              let profileCharacter = profileCharacter,
              let gender = gender?.toDTO,
              let birthYear = birthYear else {
            return nil
        }

        return UserSignUpRequest(
            socialAccessToken: socialAccessToken,
            authProvider: authProvider.rawValue,
            nickname: nickname,
            profileCharacter: profileCharacter,
            gender: gender.rawValue,
            birthYear: birthYear,
            terms: terms
        )
    }
}
