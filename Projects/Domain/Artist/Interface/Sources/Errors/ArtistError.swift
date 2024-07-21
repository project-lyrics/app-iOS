//
//  ArtistError.swift
//  DomainArtist
//
//  Created by 황인우 on 7/14/24.
//

import Core

import Foundation

public enum ArtistError: LocalizedError {
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
