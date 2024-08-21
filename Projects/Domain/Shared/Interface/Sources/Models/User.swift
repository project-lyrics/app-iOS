//
//  User.swift
//  DomainShared
//
//  Created by 황인우 on 8/17/24.
//

import Core
import Shared

import Foundation

public struct User: Hashable {
    public let id: Int
    public let nickname: String
    public let profileCharacterType: ProfileCharacterType
    
    public init(
        id: Int,
        nickname: String,
        profileCharacterType: ProfileCharacterType
    ) {
        self.id = id
        self.nickname = nickname
        self.profileCharacterType = profileCharacterType
    }
    
    public init(dto: UserDTO) {
        self.id = dto.id
        self.nickname = dto.nickname
        self.profileCharacterType = dto.profileCharacterType.toDomain
    }
}
