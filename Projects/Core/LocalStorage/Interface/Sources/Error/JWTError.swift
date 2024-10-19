//
//  JWTError.swift
//  CoreLocalStorage
//
//  Created by 황인우 on 8/31/24.
//

import Foundation

public enum JWTError: LocalizedError {
    case invalidFormat
    case decodePayloadSegmentError
    case parsePayloadJSONError
    
    public var errorDescription: String? {
        switch self {
        case .invalidFormat:                    return "잘못된 JWT 토큰 형식입니다"
        case .decodePayloadSegmentError:        return "페이로드 세그먼트를 디코딩하는 데 실패했습니다"
        case .parsePayloadJSONError:            return "페이로드 JSON을 파싱하는 데 실패했습니다"
        }
    }
    
    public var errorMessage: String {
        return errorDescription ?? "unknown error"
    }
}
