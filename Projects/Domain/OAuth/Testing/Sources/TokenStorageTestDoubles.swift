//
//  TokenStorageTestDoubles.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/28/24.
//

import Combine
import Core
import Foundation

// MARK: - FakeTokenStorage
public class FakeTokenStorage: TokenStorageInterface {
    private var storage: [String: Any] = [:]

    public init() {}

    public func read<T: TokenType>(key: String) throws -> T? {
        return storage[key] as? T
    }

    public func save<T: TokenType>(token: T, for key: String) throws {
        storage[key] = token
    }

    @discardableResult
    public func delete(for key: String) throws -> Bool {
        return storage.removeValue(forKey: key) != nil
    }
}

// MARK: - MockTokenStorage
public class MockTokenStorage: TokenStorageInterface {
    public var readResult: TokenType?
    public var saveResult: Bool = true
    public var deleteResult: Bool = true

    public var readCalled: Bool = false
    public var saveCalled: Bool = false
    public var deleteCalled: Bool = false

    public var tokenKey: String?
    
    public var saveResultCount: Int = 0
    public var readResultCount: Int = 0
    public var deleteResultCount: Int = 0

    public init() {}

    public func read<T: TokenType>(key: String) throws -> T? {
        readCalled = true
        tokenKey = key
        readResultCount += 1
        return readResult as? T
    }

    public func save<T: TokenType>(token: T, for key: String) throws {
        saveCalled = true
        tokenKey = key
        saveResultCount += 1
    }

    @discardableResult
    public func delete(for key: String) throws -> Bool {
        deleteCalled = true
        tokenKey = key
        deleteResultCount += 1
        return deleteResult
    }
}
