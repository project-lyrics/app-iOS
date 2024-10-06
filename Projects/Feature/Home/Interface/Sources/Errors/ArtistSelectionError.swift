//
//  ArtistSelectionError.swift
//  FeatureHome
//
//  Created by 황인우 on 7/15/24.
//

import Domain

import Foundation

public enum ArtistSelectionError: LocalizedError {
    case tooManyFavorites(limit: Int)
    case domainError(ArtistError)
    
    // MARK: - 추후 기획과 논의 후 메세지 수정 필요
    
    public var errorDescription: String? {
        switch self {
        case .tooManyFavorites(let limit):
            return "아티스트는 최대 \(limit)명까지\n 선택할 수 있어요."
            
        case .domainError(let artistError):
            switch artistError {
            case .networkError(let networkError):
                switch networkError {
                case .serverError, .feelinAPIError:
                    return "서버에서 아티스트 데이터를 처리하는 과정에서 문제가 생겼어요.\n 잠시 후 다시 시도 해 주세요\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
                    
                case .unknownError(let description):
                    return "알 수 없는 네트워크 오류가 발생했습니다: \(description)"
                    
                default:
                    return "디바이스에서 아티스트 데이터를 처리하는 과정에서 문제가 생겼어요.\n 잠시 후 다시 시도 해 주세요\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
                }
            case .unknown(let errorDescription):
                return "\(errorDescription).\n잠시 후 다시 시도 해 주세요.\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
                
            case .keychainError:
                return "인증 처리과정에서 문제가 생겼어요. \n잠시 후 다시 시도 해 주세요.\n 문제가 지속적으로 발생한다면 관리자에게 문의 주세요."
            }
        }
    }
    
    public init(error: Error) {
        if let domainError = error as? ArtistError {
            self = .domainError(domainError)
        } else {
            self = .domainError(.unknown(errorDescription: error.localizedDescription))
        }
    }
}
