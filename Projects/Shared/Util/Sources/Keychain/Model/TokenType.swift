//
//  TokenType.swift
//  SharedUtil
//
//  Created by 황인우 on 10/31/24.
//

import Foundation

// MARK: - TokenType
public protocol TokenType: Codable {
    var token: String { get }
    var expiration: Date { get }
    
    init(token: String, expiration: Date)
}

// MARK: - AccessToken
public struct AccessToken: TokenType {
    public let token: String
    public let expiration: Date
    
    public init(token: String, expiration: Date) {
        self.token = token
        self.expiration = expiration
    }
}

// MARK: - RefreshToken
public struct RefreshToken: TokenType {
    public let token: String
    public let expiration: Date
    
    public init(token: String, expiration: Date) {
        self.token = token
        self.expiration = expiration
    }
}
