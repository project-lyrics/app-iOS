//
//  UserProfileError.swift
//  DomainUserProfileInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation

import Core
import Shared

public enum UserProfileError: LocalizedError {
    case networkError(NetworkError)
    case keychainError(KeychainError)
    case bundleError(BundleError)
    case unknown(errorDescription: String)

    public var errorDescription: String {
        switch self {
        case .networkError(let error):
            return error.errorMessage
            
        case .bundleError(let error):
            return error.errorMessage

        case .keychainError(let error):
            return error.errorDescription

        case .unknown(let errorDescription):
            return errorDescription
        }
    }

    public var errorCode: String? {
        guard case .networkError(let networkError) = self,
              case .feelinAPIError(let feelinAPIError) = networkError else {
            return nil
        }

        return feelinAPIError.errorCode
    }

    public init(error: Error) {
        if let networkError = error as? NetworkError {
            self = .networkError(networkError)
        } else if let keychainError = error as? KeychainError {
            self = .keychainError(keychainError)
        } else if let bundleError = error as? BundleError {
            self = .bundleError(bundleError)
        } else {
            self = .unknown(errorDescription: error.localizedDescription)
        }
    }
}
