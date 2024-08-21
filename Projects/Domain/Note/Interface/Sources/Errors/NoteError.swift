//
//  NoteError.swift
//  DomainNote
//
//  Created by 황인우 on 8/17/24.
//

import Core

import Foundation

public enum NoteError: LocalizedError {
    case networkError(NetworkError)
    case keychainError(KeychainError)
    case unknown(errorDescription: String)
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.errorMessage
            
        case .keychainError(let error):
            return error.errorDescription
            
        case .unknown(let errorDescription):
            return errorDescription
        }
    }
    
    var errorCode: String? {
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
        } else {
            self = .unknown(errorDescription: error.localizedDescription)
        }
    }
}
