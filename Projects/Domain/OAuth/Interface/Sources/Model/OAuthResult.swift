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
}

public enum OAuthResult: Equatable {
    case success(OAuthType)
    case failure(AuthError)
}
