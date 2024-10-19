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

    public var errorDescription: String {
        switch self {
        case .domainError(let songError):
            switch songError {
            case .networkError(let networkError):
                return "서버에서 곡 데이터를 처리하는 과정에서 문제가 생겼어요.\n문제가 지속적으로 발생한다면 관리자에게 문의 주세요.\n\(networkError.errorMessage). 에러코드:\(networkError.errorCode)"
                
            case .feelinAPIError(let feelinAPIError):
                return "서버에서 곡 데이터를 처리하는 과정에서 문제가 생겼어요.\n 에러코드(\(feelinAPIError.errorCode)"
                
            case .unknown(let errorDescription):
                return "\(errorDescription).\n잠시 후 다시 시도 해 주세요.\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."

            case .keychainError:
                return "인증 처리과정에서 문제가 생겼어요. \n잠시 후 다시 시도 해 주세요.\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
            }
        }
    }
    
    public var errorMessage: String {
        return self.errorDescription
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

    public init(error: Error) {
        if let domainError = error as? NoteError {
            self = .domainError(domainError)
        } else {
            self = .domainError(.unknown(errorDescription: error.localizedDescription))
        }
    }
}
