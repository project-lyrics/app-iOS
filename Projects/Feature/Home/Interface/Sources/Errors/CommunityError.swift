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
            return noteError.errorDescription
        case .artistError(let artistError):
            return artistError.errorDescription
        case .unknownError(let description):
            return description
        }
    }
}
