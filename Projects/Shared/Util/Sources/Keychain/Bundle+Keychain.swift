//
//  Bundle+Keychain.swift
//  SharedUtil
//
//  Created by 황인우 on 8/31/24.
//

import Foundation

public extension Bundle {
    var accessTokenKey: String? {
        return self.object(forInfoDictionaryKey: "ACCESS_TOKEN_KEY") as? String
    }
    
    var refreshTokenKey: String? {
        return self.object(forInfoDictionaryKey: "REFRESH_TOKEN_KEY") as? String
    }
}
