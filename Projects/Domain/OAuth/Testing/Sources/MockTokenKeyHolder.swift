//
//  MockTokenKeyHolder.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/13/24.
//

import DomainOAuthInterface
import Foundation
import SharedUtil

struct MockTokenKeyHolder: TokenKeyHolderInterface {
    var expectedAccessTokenKey: String?
    var expectedRefreshTokenKey: String?
    
    init(
        expectedAccessTokenKey: String?,
        expectedRefreshTokenKey: String?
    ) {
        self.expectedAccessTokenKey = expectedAccessTokenKey
        self.expectedRefreshTokenKey = expectedRefreshTokenKey
    }
    
    func fetchAccessTokenKey() throws -> String {
        if let expectedAccessTokenKey = expectedAccessTokenKey {
            return expectedAccessTokenKey
        } else {
            throw BundleError.missingItem(itemName: "AccessTokenKey")
        }
    }
    
    func fetchRefreshTokenKey() throws -> String {
        if let expectedRefreshTokenKey = expectedRefreshTokenKey {
            return expectedRefreshTokenKey
        } else {
            throw BundleError.missingItem(itemName: "RefreshTokenKey")
        }
    }
}
