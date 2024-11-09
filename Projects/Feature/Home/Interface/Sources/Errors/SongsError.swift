//
//  SongsError.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 9/1/24.
//

import Domain

import Foundation

public enum SongsError: LocalizedError {
    case domainError(NoteError)
    
    public var errorMessage: String {
        return self.userMessage
    }
    
    public var errorCode: String? {
        switch self {
        case .domainError(let noteError):
            return noteError.errorCode
        }
    }
    
    public var errorMessageWithCode: String {
        return errorMessage + "\n에러코드(\(errorCode ?? "nil"))"
    }
    
    public var userMessage: String {
        switch self {
        case .domainError(let noteError):
            switch noteError {
            case .feelinAPIError(let feelinAPIError):
                return feelinAPIError.userMessage
                
            default:
                return "클라이언트 오류입니다. \n잠시 후 다시 시도해 주세요."
            }
        }
    }

    public init(error: Error) {
        if let domainError = error as? NoteError {
            self = .domainError(domainError)
        } else {
            self = .domainError(.unknown(errorDescription: error.localizedDescription))
        }
    }
}
