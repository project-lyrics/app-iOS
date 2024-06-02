//
//  KakaoUserAPITestDoubles.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/28/24.
//

import DomainOAuthInterface
import Foundation
import XCTest

final public class MockKakaoUserAPI: KakaoUserAPIProtocol {
    public var oAuthToken: KakaoOAuthToken?
    public var error: KakaoSDKError?
    
    public init(
        oAuthToken: KakaoOAuthToken?,
        error: KakaoSDKError?
    ) {
        self.oAuthToken = oAuthToken
        self.error = error
    }
    
    public func loginWithKakaoTalk(
        launchMethod: KakaoLaunchMethod? = .UniversalLink,
        channelPublicIds: [String]? = nil,
        serviceTerms: [String]? = nil,
        nonce: String? = nil,
        completion: @escaping (KakaoOAuthToken?, Error?) -> Void
    ) {
        if let error = error {
            completion(nil, error)
        }
        
        if let validOAuthToken = oAuthToken {
            completion(validOAuthToken, nil)
        } else {
            completion(nil, KakaoSDKError.ClientFailed(reason: .TokenNotFound, errorMessage: "mock객체에게 토큰을 주입해야 한다."))
        }
    }
    
    public func loginWithKakaoAccount(
        prompts: [KakaoAuthPrompt]? = nil,
        channelPublicIds: [String]? = nil,
        serviceTerms: [String]? = nil,
        nonce: String? = nil,
        completion: @escaping (KakaoOAuthToken?, Error?) -> Void
    ) {
        if let error = error {
            completion(nil, error)
        }
        if let validOAuthToken = oAuthToken {
            completion(validOAuthToken, nil)
        } else {
            completion(nil, KakaoSDKError.ClientFailed(reason: .TokenNotFound, errorMessage: "mock객체에게 토큰을 주입해야 한다."))
        }
    }
}
