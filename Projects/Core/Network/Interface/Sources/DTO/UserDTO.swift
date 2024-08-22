//
//  UserDTO.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 8/15/24.
//

import Foundation

import Shared

public struct UserDTO: Codable {
    public let id: Int
    public let nickname: String
    public let profileCharacterType: ProfileCharacterTypeDTO
}


public enum ProfileCharacterTypeDTO: String, Codable {
    case shortHair
    case braidedHair
    case partedHair
    case poopHair
    
    public var toDomain: ProfileCharacterType {
        switch self {
        case .shortHair:        return .shortHair
        case .braidedHair:      return .braidedHair
        case .partedHair:       return .partedHair
        case .poopHair:         return .poopHair
        }
    }
}
