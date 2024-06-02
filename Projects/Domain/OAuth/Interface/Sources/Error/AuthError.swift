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

public enum AuthError: LocalizedError {
    case kakaoSdkError(KakaoSDKError)
    case keychainError(KeychainError)
    case networkError(NetworkError)
    case jwtParsingError(JWTError)
    case unidentifiedError(Error)
}
