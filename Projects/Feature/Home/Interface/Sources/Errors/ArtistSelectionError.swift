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
        return userMessage
    }
    
    public var userMessage: String {
        switch self {
        case .tooManyFavorites(let limit):
            return "아티스트는 최대 \(limit)명까지\n 선택할 수 있어요."
            
        case .domainError(let artistError):
            switch artistError {
            case .feelinAPIError(let feelinAPiError):
                return feelinAPiError.userMessage
                
            default:
                return "클라이언트 오류입니다.\n잠시 후 다시 시도해 주세요."
            }
        }
    }
    
    public var errorCode: String? {
        switch self {
        case .domainError(let artistError):
            switch artistError {
            case .feelinAPIError(let feelinAPIError):
                return feelinAPIError.errorCode
                
            default:
                return nil
            }
        default:
            return nil
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
