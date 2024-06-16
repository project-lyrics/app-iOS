//
//  AuthError.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/26/24.
//

import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation
import KakaoSDKCommon

public enum AuthError: LocalizedError, Equatable {
    public static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case kakaoOAuthError(KakaoOAuthError)
    case appleOAuthError(AppleOAuthError)
    case keychainError(KeychainError)
    case networkError(NetworkError)
    case jwtParsingError(JWTError)
    case unExpectedError(Error)
}
