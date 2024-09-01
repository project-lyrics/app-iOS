//
//  KeychainWrapper.swift
//  SharedUtil
//
//  Created by 황인우 on 8/31/24.
//

import Foundation

@propertyWrapper
public struct KeychainWrapper<T: Codable> {
    private let category: KeychainCategory
    private let keychain: Keychain
    
    public var wrappedValue: T? {
        get {
            guard let key = self.category.key else {
                fatalError("missing key of \(category) in bundle")
            }
            
            guard let data = try? keychain.read(key: key) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            guard let key = self.category.key else {
                fatalError("missing key of \(category) in bundle")
            }
            
            guard let value = newValue else {
                try? keychain.delete(key: key)
                return
            }
            let data = try? JSONEncoder().encode(value)
            if let data = data {
                try? keychain.save(key: key, data: data)
            }
        }
    }
    
    public init(
        _ category: KeychainCategory,
        keychain: Keychain = Keychain()
    ) {
        self.category = category
        self.keychain = keychain
    }
}
