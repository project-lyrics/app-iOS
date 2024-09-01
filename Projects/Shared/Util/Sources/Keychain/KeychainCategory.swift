//
//  KeychainCategory.swift
//  SharedUtil
//
//  Created by 황인우 on 8/31/24.
//

import Foundation

public enum KeychainCategory: Equatable {
    case accessToken
    case refreshToken
    case userID
    
    public var key: String? {
        switch self {
        case .accessToken:      return Bundle.main.accessTokenKey
        case .refreshToken:     return Bundle.main.refreshTokenKey
        case .userID:           return Bundle.main.userIDKey
        }
    }
}
