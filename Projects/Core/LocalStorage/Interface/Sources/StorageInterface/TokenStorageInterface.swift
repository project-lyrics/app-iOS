//
//  TokenStorageInterface.swift
//  CoreLocalStorageInterface
//
//  Created by 황인우 on 5/19/24.
//

import Foundation

public protocol TokenStorageInterface {
    func read<T: TokenType>(key: String) throws -> T?
    func save<T: TokenType>(
        token: T,
        for key: String
    ) throws
    @discardableResult
    func delete(for key: String) throws -> Bool
}
