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
    case feelinAPIError(FeelinAPIError)
    case userNotFound(UserNotFoundResult)
    case jwtParsingError(JWTError)
    case unExpectedError(Error)
    
    public var errorCode: String? {
        switch self {
        case .networkError(let networkError):
            return networkError.errorCode
        default:
            return nil
        }
    }
    
    public var errorMessage: String {
        switch self {
        case .kakaoOAuthError(let kakaoOAuthError):
            switch kakaoOAuthError {
            case .ApiFailed(let reason, let errorInfo):
                return "Kakao API Error. reason: \(reason) info: \(errorInfo?.msg ?? "")"
            case .AppsFailed(let reason, let errorInfo):
                return "Kakao API Error. reason: \(reason) errorCode: \(errorInfo?.errorCode ?? .Unknown)"
            case .AuthFailed(let reason, let errorInfo):
                return "Kakao API Error. reason: \(reason) errorCodr: \(errorInfo?.error ?? .Unknown)"
            case .ClientFailed(let reason, let errorInfo):
                return "Kakao API Error. reason: \(reason) info: \(errorInfo?.description ?? "")"
            }
            
        case .appleOAuthError(let appleOAuthError):
            return appleOAuthError.errorMessage
            
        case .keychainError(let keychainError):
            return keychainError.errorMessage
            
        case .networkError(let networkError):
            return networkError.errorMessage
            
        case .userNotFound:
            return "회원정보 입력이 필요합니다."
            
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.errorMessage
            
        case .jwtParsingError(let jWTError):
            return jWTError.errorMessage
            
        case .unExpectedError(let error):
            return "unknown authError: \(error.localizedDescription)"
            
        }
    }
}
