//
//  ReportError.swift
//  DomainReport
//
//  Created by Derrick kim on 9/22/24.
//

import Foundation

import Core
import Shared

public enum ReportError: LocalizedError {
    case networkError(NetworkError)
    case feelinAPIError(FeelinAPIError)
    case keychainError(KeychainError)
    case unknown(errorDescription: String)
    
    public var errorMessage: String {
        switch self {
        case .networkError(let error):
            return error.errorMessage
            
        case .feelinAPIError(let error):
            return error.errorMessage
            
        case .keychainError(let error):
            return error.errorDescription
            
        case .unknown(let errorDescription):
            return errorDescription
        }
    }
    
    public var errorCode: String? {
        switch self {
        case .networkError(let networkError):
            return networkError.errorCode
            
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.errorCode
            
        default:
            return nil
        }
    }
    
    public var errorMessageWithCode: String {
        return errorMessage + "\n에러코드(\(errorCode ?? "nil"))"
    }
    
    
    public init(error: Error) {
        if let networkError = error as? NetworkError {
            if case .feelinAPIError(let feelinAPIError) = networkError {
                self = .feelinAPIError(feelinAPIError)
            } else {
                self = .networkError(networkError)
            }
        } else if let keychainError = error as? KeychainError {
            self = .keychainError(keychainError)
        } else {
            self = .unknown(errorDescription: error.localizedDescription)
        }
    }
}
