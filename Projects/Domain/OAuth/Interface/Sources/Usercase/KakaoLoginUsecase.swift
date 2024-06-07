//
//  KakaoLoginUseCase.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/28/24.
//

import Combine
import Foundation

public struct KakaoLoginUseCase {
    private let kakaoOAuthService: KakaoOAuthServiceInterface
    
    public init(kakaoOAuthService: KakaoOAuthServiceInterface) {
        self.kakaoOAuthService = kakaoOAuthService
    }
    
    public func execute() -> AnyPublisher<OAuthResult, AuthError> {
        return kakaoOAuthService.login()
    }
}
