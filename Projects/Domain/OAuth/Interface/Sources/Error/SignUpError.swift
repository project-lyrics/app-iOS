//
//  SignUpError.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/9/24.
//

import Foundation

import Core
import Shared

public enum SignUpError: LocalizedError, Equatable {
    public static func == (lhs: SignUpError, rhs: SignUpError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }

    case bundleError(BundleError)
    case keychainError(KeychainError)
    case networkError(NetworkError)
    case jwtParsingError(JWTError)
    case feelinAPIError(FeelinAPIError)
    case unExpectedError(Error)

    public var errorMessage: String {
        switch self {
        case .networkError(let error):
            return error.errorMessage

        case .keychainError(let error):
            return error.errorMessage

        case .feelinAPIError(let error):
            return error.errorMessage

        case .bundleError(let error):
            return error.errorMessage

        case .jwtParsingError(let jWTError):
            return jWTError.errorMessage

        case .unExpectedError(let error):
            return "unknown authError: \(error.localizedDescription)"
        }
    }

    public var errorCode: String? {
        switch self {
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.errorCode
        case .networkError(let networkError):
            return networkError.errorCode
        default:
            return nil
        }
    }

    public var errorMessageWithCode: String {
        return errorMessage + "\n에러코드(\(errorCode ?? "nil"))"
    }
    
    public var userMessage: String {
        switch self {
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.userMessage
            
        default:
            return "클라이언트 오류입니다. \n잠시 후 다시 시도해 주세요."
        }
    }
}
