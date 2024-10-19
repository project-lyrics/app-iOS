//
//  UserNotFoundResult.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 10/19/24.
//

import Foundation

public struct UserNotFoundResult: Equatable {
    public let accessToken: String
    public let oAuthType: OAuthType
    
    public init(
        accessToken: String,
        oAuthType: OAuthType
    ) {
        self.accessToken = accessToken
        self.oAuthType = oAuthType
    }
}
