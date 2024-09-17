//
//  SongsError.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 9/1/24.
//

import Domain

import Foundation

public enum SongsError: LocalizedError {
    case domainError(NoteError)

    public var errorDescription: String? {
        switch self {
        case .domainError(let songError):
            switch songError {
            case .networkError(let networkError):
                switch networkError {
                case .serverError, .feelinAPIError:
                    return "서버에서 곡 데이터를 처리하는 과정에서 문제가 생겼어요.\n 잠시 후 다시 시도 해 주세요\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."

                case .unknownError(let description):
                    return "알 수 없는 네트워크 오류가 발생했습니다: \(description)"

                default:
                    return "디바이스에서 곡 데이터를 처리하는 과정에서 문제가 생겼어요.\n 잠시 후 다시 시도 해 주세요\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
                }
            case .unknown(let errorDescription):
                return "\(errorDescription).\n잠시 후 다시 시도 해 주세요.\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."

            case .keychainError:
                return "인증 처리과정에서 문제가 생겼어요. \n잠시 후 다시 시도 해 주세요.\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
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
