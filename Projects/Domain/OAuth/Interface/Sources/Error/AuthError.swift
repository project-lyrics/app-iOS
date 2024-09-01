//
//  AuthError.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/26/24.
//

import Foundation

import Core
import KakaoSDKCommon
import Shared

public enum AuthError: LocalizedError, Equatable {
    public static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case kakaoOAuthError(KakaoOAuthError)
    case appleOAuthError(AppleOAuthError)
    case keychainError(KeychainError)
    case networkError(NetworkError)
    case feelinError(FeelinError)
    case jwtParsingError(JWTError)
    case unExpectedError(Error)
}
