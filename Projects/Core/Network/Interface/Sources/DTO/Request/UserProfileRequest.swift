//
//  UserProfileRequest.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation

public struct UserProfileRequest: Encodable {
    public let nickname: String?
    public let profileCharacter: String?
    public var gender: Gender?
    public var birthYear: Int?

    public init(
        nickname: String? = nil,
        profileCharacter: String? = nil,
        gender: Gender? = nil,
        birthYear: Int? = nil
    ) {
        self.nickname = nickname
        self.profileCharacter = profileCharacter
        self.gender = gender
        self.birthYear = birthYear
    }
}
