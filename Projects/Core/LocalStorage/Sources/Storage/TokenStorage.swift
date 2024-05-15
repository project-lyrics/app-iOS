//
//  TokenRepository.swift
//  CoreLocalStorageInterface
//
//  Created by 황인우 on 5/15/24.
//

import CoreLocalStorageInterface
import Foundation

protocol TokenStorageInterface {
	func read<T: TokenType>(key: String) throws -> T
	@discardableResult
	func save<T: TokenType>(
		token: T,
		for key: String
	) throws -> Bool
	@discardableResult
	func delete(for key: String) throws -> Bool
}

// MARK: - TokenStorage
struct TokenStorage: TokenStorageInterface {
	private let keychain: Keychain
	
	func read<T: TokenType>(key: String) throws -> T {
		let data = try keychain.read(key: key)
		return try JSONDecoder().decode(T.self, from: data)
	}
	
	@discardableResult
	func save<T: TokenType>(
		token: T,
		for key: String
	) throws -> Bool {
		let data = try JSONEncoder().encode(token)
		return try keychain.save(key: key, data: data)
	}
	
	@discardableResult
	func delete(for key: String) throws -> Bool {
		return try keychain.delete(key: key)
	}
}
