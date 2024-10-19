//
//  CommunityError.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/3/24.
//

import Domain

import Foundation

public enum CommunityError: LocalizedError {
    case noteError(NoteError)
    case artistError(ArtistError)
    case unknownError(description: String)
    
    public init(error: Error) {
        if let artistError = error as? ArtistError {
            self = .artistError(artistError)
        } else if let noteError = error as? NoteError {
            self = .noteError(noteError)
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
        case .unknownError:
            return nil
        }
    }
    
    public var errorMessageWithCode: String {
        return errorMessage + "\n에러코드(\(errorCode ?? "nil"))"
    }
}
