//
//  OAuthLoginUseCase.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/28/24.
//

import Combine
import Foundation

public struct OAuthLoginUseCase {
    private let oAuthService: OAuthServiceInterface & UserVerifiable
    
    public init(oAuthService: OAuthServiceInterface & UserVerifiable) {
        self.oAuthService = oAuthService
    }
    
    public func execute() -> AnyPublisher<OAuthResult, AuthError> {
        return oAuthService.login()
    }
}
