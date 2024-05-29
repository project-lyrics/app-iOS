//
//  KakaoUserAPIProtocol.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/28/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

public protocol KakaoUserAPIProtocol {
    func loginWithKakaoTalk(
        launchMethod: KakaoLaunchMethod?,
        channelPublicIds: [String]?,
        serviceTerms: [String]?,
        nonce: String?,
        completion: @escaping (KakaoOAuthToken?, Error?) -> Void
    )
    
    func loginWithKakaoAccount(
        prompts : [KakaoAuthPrompt]?,
        channelPublicIds: [String]?,
        serviceTerms: [String]?,
        nonce: String?,
        completion: @escaping (KakaoOAuthToken?, Error?) -> Void
    )
}

extension UserApi: KakaoUserAPIProtocol { }
