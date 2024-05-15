//
//  Token.swift
//  CoreLocalStorageInterface
//
//  Created by 황인우 on 5/15/24.
//

import Foundation

// MARK: - TokenType
public protocol TokenType: Codable {
	var token: String { get }
	var expiration: Date { get }
}

// MARK: - AccessToken
struct AccessToken: TokenType {
	let token: String
	let expiration: Date
}

// MARK: - RefreshToken
struct RefreshToken: Codable {
	let token: String
	let expiration: Date
}
