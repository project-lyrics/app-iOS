//
//  UserInfoStorage.swift
//  CoreLocalStorage
//
//  Created by 황인우 on 9/1/24.
//

import CoreLocalStorageInterface
import SharedUtil

import Foundation

public struct UserInfoStorage: UserInfoStorageInterface {
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
    
    public func read() throws -> UserInformation? {
        do {
            guard let userInfoKey = Bundle.main.userInfoKey else {
                throw BundleError.missingItem(itemName: "userInfoKey")
            }
            
            guard let data = try keychain.read(key: userInfoKey) else {
                return nil
            }
            return try JSONDecoder().decode(UserInformation.self, from: data)
        } catch {
            throw error
        }
    }
    
    public func save(userInformation: UserInformation) throws {
        let data = try JSONEncoder().encode(userInformation)
        
        guard let userInfoKey = Bundle.main.userInfoKey else {
            throw BundleError.missingItem(itemName: "userInfoKey")
        }
        
        try keychain.save(key: userInfoKey, data: data)
    }
    
    @discardableResult
    public func delete() throws -> Bool {
        guard let userInfoKey = Bundle.main.userInfoKey else {
            throw BundleError.missingItem(itemName: "userInfoKey")
        }
        
        return try keychain.delete(key: userInfoKey)
    }
}
