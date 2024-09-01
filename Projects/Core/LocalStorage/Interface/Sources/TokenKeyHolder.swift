//
//  TokenKeyHolder.swift
//  CoreLocalStorage
//
//  Created by 황인우 on 8/31/24.
//

import Foundation
import SharedUtil

public protocol TokenKeyHolderInterface {
    func fetchAccessTokenKey() throws -> String
    func fetchRefreshTokenKey() throws -> String
}

public struct TokenKeyHolder: TokenKeyHolderInterface {
    public init() {}
    
    public func fetchAccessTokenKey() throws -> String {
        if let accessTokenKey = Bundle.main.accessTokenKey {
            return accessTokenKey
        } else {
            throw BundleError.missingItem(itemName: "AccessTokenKey")
        }
    }
    
    public func fetchRefreshTokenKey() throws -> String {
        if let refreshTokenKey = Bundle.main.refreshTokenKey {
            return refreshTokenKey
        } else {
            throw BundleError.missingItem(itemName: "RefreshTokenKey")
        }
    }
}
