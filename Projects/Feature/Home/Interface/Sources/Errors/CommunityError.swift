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
    case userProfileError(UserProfileError)
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
        } else if let userProfileError = error as? UserProfileError {
            if case let .feelinAPIError(feelinAPIError) = userProfileError {
                self = .feelinAPIError(feelinAPIError)
            } else {
                self = .userProfileError(userProfileError)
            }
        }else {
            self = .unknownError(description: error.localizedDescription)
        }
    }
    
    public var errorDescription: String {
        switch self {
        case .noteError(let noteError):
            return noteError.errorMessage
            
        case .artistError(let artistError):
            return artistError.errorMessage
            
        case .userProfileError(let userProfileError):
            return userProfileError.errorMessage
            
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
        case .userProfileError(let userProfileError):
            return userProfileError.errorCode
        case .feelinAPIError(let feelinAPiError):
            return feelinAPiError.errorCode
        case .unknownError:
            return nil
        }
    }
    
    public var userMessage: String {
        switch self {
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.userMessage
            
        default:
            return "클라이언트 오류입니다. \n잠시 후 다시 시도해 주세요."
        }
    }
    
    public var data: AnyType? {
        switch self {
        case .feelinAPIError(let feelinAPIError):
            return feelinAPIError.data
            
        default:
            return nil
        }
    }
    
    public var errorMessageWithCode: String {
        return errorMessage + "\n에러코드(\(errorCode ?? "nil"))"
    }
}
