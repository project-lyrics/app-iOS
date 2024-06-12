//
//  OAuthResult.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/26/24.
//

import Foundation

public enum OAuthType: String {
    case kakaoLogin
    case appleLogin
    case none
}

public struct OAuthResult: Equatable {
    public let oAuthType: OAuthType
    
    public init(oAuthType: OAuthType) {
        self.oAuthType = oAuthType
    }
}
