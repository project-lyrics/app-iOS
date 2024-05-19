//
//  TokenRepository.swift
//  CoreLocalStorageInterface
//
//  Created by 황인우 on 5/15/24.
//

import CoreLocalStorageInterface
import Foundation

// MARK: - TokenStorage
public struct TokenStorage: TokenStorageInterface {
    public let keychain: Keychain
    
    public init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    public init() {
        self.keychain = .init()
    }
    
    public init(option: Keychain.Option) {
        self.keychain = Keychain(option: option)
    }
    
    public func read<T: TokenType>(key: String) throws -> T? {
        do {
            guard let data = try keychain.read(key: key) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    @discardableResult
    public func save<T: TokenType>(
        token: T,
        for key: String
    ) throws {
        let data = try JSONEncoder().encode(token)
        try keychain.save(key: key, data: data)
    }
    
    @discardableResult
    public func delete(for key: String) throws -> Bool {
        return try keychain.delete(key: key)
    }
}
