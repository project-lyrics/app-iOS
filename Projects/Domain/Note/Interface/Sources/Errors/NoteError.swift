//
//  NoteError.swift
//  DomainNote
//
//  Created by 황인우 on 8/17/24.
//

import Foundation

import Core
import Shared

public enum NoteError: LocalizedError, Equatable {
    case feelinAPIError(FeelinAPIError)
    case networkError(NetworkError)
    case keychainError(KeychainError)
    case unknown(errorDescription: String)
    
    public var errorMessage: String {
        switch self {
        case .networkError(let error):
            return error.errorMessage
            
        case .keychainError(let error):
            return error.errorMessage
            
        case .unknown(let errorDescription):
            return errorDescription
            
        case .feelinAPIError(let error):
            return error.errorMessage
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
