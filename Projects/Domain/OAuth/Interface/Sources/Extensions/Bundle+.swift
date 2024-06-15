//
//  Bundle+.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/13/24.
//

import Foundation

extension Bundle {
    var accessTokenKey: String? {
        return self.object(forInfoDictionaryKey: "ACCESS_TOKEN_KEY") as? String
    }
    
    var refreshTokenKey: String? {
        return self.object(forInfoDictionaryKey: "REFRESH_TOKEN_KEY") as? String
    }
}
