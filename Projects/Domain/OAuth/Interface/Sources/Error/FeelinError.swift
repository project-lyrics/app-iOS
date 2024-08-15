//
//  FeelinError.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/17/24.
//

import Foundation

public enum FeelinError: Error {
    case userNotFound((accessToken: String, oAuthType: OAuthType))
}
