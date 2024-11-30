//
//  HomeError.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/17/24.
//

import Domain
import Shared

import Foundation

public enum HomeError: LocalizedError, Equatable {
    case noteError(NoteError)
    case artistError(ArtistError)
    case userProfileError(UserProfileError)
    case unknownError(description: String)
    
    public init(error: Error) {
        if let artistError = error as? ArtistError {
            self = .artistError(artistError)
        } else if let noteError = error as? NoteError {
            self = .noteError(noteError)
        } else if let userProfileError = error as? UserProfileError {
            self = .userProfileError(userProfileError)
        } else {
            self = .unknownError(description: error.localizedDescription)
        }
    }
    
    public var errorDescription: String {
        switch self {
        case .noteError(let noteError):
            return noteError.errorMessage + "에러코드: \(noteError.errorCode ?? "nil")"
            
        case .artistError(let artistError):
            return artistError.errorMessage + "에러코드: \(artistError.errorCode ?? "nil")"
            
        case .userProfileError(let userProfileError):
            return userProfileError.errorMessage + "에러코드: \(userProfileError.errorCode ?? "nil")"
            
        case .unknownError(let description):
            return description
        }
    }
    
    public var errorMessage: String {
        return self.errorDescription
    }
    
    public var userMessage: String {
        switch self {
        case .noteError(let noteError):
            return noteError.userMessage
            
        case .artistError(let artistError):
            return artistError.userMessage
            
        case .userProfileError(let userProfileError):
            return userProfileError.userMessage
            
        case .unknownError(let unknownError):
            return unknownError
        }
    }
    
    public var data: AnyType? {
        switch self {
        case .noteError(let noteError):
            return noteError.data
        
        case .artistError(let artistError):
            return artistError.data
            
        case .userProfileError(let userProfileError):
            return userProfileError.data
        
        default:
            return nil
        }
    }
    
    public var errorCode: String? {
        switch self {
        case .noteError(let noteError):
            return noteError.errorCode
        case .artistError(let artistError):
            return artistError.errorCode
        case .userProfileError(let userProfileError):
            return userProfileError.errorCode
        case .unknownError:
            return nil
        }
    }
}
