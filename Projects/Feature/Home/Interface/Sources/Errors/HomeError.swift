//
//  HomeError.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/17/24.
//

import Domain

import Foundation

public enum HomeError: LocalizedError {
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
            return noteError.errorMessage + "에러코드: \(noteError.errorCode ?? "nil")"
            
        case .artistError(let artistError):
            return artistError.errorMessage + "에러코드: \(artistError.errorCode ?? "nil")"
            
        case .unknownError(let description):
            return description
        }
    }
    
    public var errorMessage: String {
        return self.errorDescription
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
}
