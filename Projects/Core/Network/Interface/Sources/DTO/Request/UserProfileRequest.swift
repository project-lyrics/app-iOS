//
//  UserProfileRequest.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation

public struct UserProfileRequest: Encodable {
    public let nickname: String
    public let profileCharacter: String

    public init(
        nickname: String,
        profileCharacter: String
    ) {
        self.nickname = nickname
        self.profileCharacter = profileCharacter
    }
}
