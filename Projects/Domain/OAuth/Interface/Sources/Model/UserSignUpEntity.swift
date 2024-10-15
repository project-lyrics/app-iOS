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
    public var isAdmin: Bool

    public init(
        socialAccessToken: String? = nil,
        oAuthType: OAuthType? = nil,
        nickname: String? = nil,
        profileCharacter: String? = nil,
        gender: GenderEntity? = nil,
        birthYear: String? = nil,
        terms: [Term] = [],
        isAdmin: Bool = false
    ) {
        self.socialAccessToken = socialAccessToken
        self.oAuthType = oAuthType
        self.nickname = nickname
        self.profileCharacter = profileCharacter
        self.gender = gender
        self.birthYear = birthYear
        self.terms = terms
        self.isAdmin = isAdmin
    }

    public func toDTO() -> UserSignUpRequest {
        let oAuthType = oAuthType ?? .apple
        let authProvider = OAuthProvider(rawValue: oAuthType.rawValue) ?? .apple

        return UserSignUpRequest(
            socialAccessToken: socialAccessToken ?? "",
            authProvider: authProvider.rawValue,
            nickname: nickname ?? "",
            profileCharacter: profileCharacter ?? "",
            gender: gender?.toDTO.rawValue ?? "",
            birthYear: birthYear ?? "",
            terms: terms,
            isAdmin: isAdmin
        )
    }
}
