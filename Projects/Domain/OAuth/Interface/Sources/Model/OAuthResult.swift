//
//  OAuthResult.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/26/24.
//

import Foundation

public enum OAuthType: String {
    case kakao
    case apple
    case none
}

public struct OAuthResult: Equatable {
    public let oAuthType: OAuthType
    
    public init(oAuthType: OAuthType) {
        self.oAuthType = oAuthType
    }
}
