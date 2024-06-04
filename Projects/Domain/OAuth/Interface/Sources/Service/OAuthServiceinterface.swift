//
//  OAuthServiceinterface.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import Foundation

public protocol OAuthServiceInterface {
    func login() -> AnyPublisher<OAuthResult, AuthError>
}
