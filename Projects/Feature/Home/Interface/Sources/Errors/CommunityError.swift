//
//  CommunityError.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/3/24.
//

import Domain
import Shared

import Foundation

public enum CommunityError: LocalizedError, Equatable {
    case noteError(NoteError)
    case artistError(ArtistError)
    case feelinAPIError(FeelinAPIError)
    case unknownError(description: String)
    
    public init(error: Error) {
        if let artistError = error as? ArtistError {
            if case let .feelinAPIError(feelinAPIError) = artistError {
                self = .feelinAPIError(feelinAPIError)
            } else {
                self = .artistError(artistError)
            }
        } else if let noteError = error as? NoteError {
            if case let .feelinAPIError(feelinAPIError) = noteError {
                self = .feelinAPIError(feelinAPIError)
            } else {
                self = .noteError(noteError)
            }
        } else {
            self = .unknownError(description: error.localizedDescription)
        }
    }
    
    public var errorDescription: String {
        switch self {
        case .noteError(let noteError):
            return noteError.errorMessage
            
        case .artistError(let artistError):
            return artistError.errorMessage
            
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.errorMessage
            
        case .unknownError(let description):
            return description
        }
    }
    
    public var errorMessage: String {
        return errorDescription
    }
    
    public var errorCode: String? {
        switch self {
        case .noteError(let noteError):
            return noteError.errorCode
        case .artistError(let artistError):
            return artistError.errorCode
        case .feelinAPIError(let feelinAPiError):
            return feelinAPiError.errorCode
        case .unknownError:
            return nil
        }
    }
    
    public var errorMessageWithCode: String {
        return errorMessage + "\n에러코드(\(errorCode ?? "nil"))"
    }
}
