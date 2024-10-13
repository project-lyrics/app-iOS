//
//  OAuthResult.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/26/24.
//

import Foundation

public enum OAuthType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case none

    public var info: String {
        switch self {
        case .kakao:
            return "카카오 로그인"
        case .apple:
            return "Apple 로그인"
        case .none:
            return ""
        }
    }
}

public enum OAuthResult: Equatable {
    case success(OAuthType)
    case failure(AuthError)
}
