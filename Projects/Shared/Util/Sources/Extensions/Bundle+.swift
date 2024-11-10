//
//  Bundle+.swift
//  SharedUtil
//
//  Created by 황인우 on 5/24/24.
//

import Foundation

extension Bundle {
    public var kakaoNativeAppKey: String? {
        return self.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String
    }
    
    public var baseServerURL: String? {
        return self.object(forInfoDictionaryKey: "BASE_SERVER_URL") as? String
    }
    
    public var appVersion: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
