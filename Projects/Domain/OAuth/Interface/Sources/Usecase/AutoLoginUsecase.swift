//
//  AutoLoginUsecase.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Combine
import Foundation

public struct AutoLoginUsecase {
    private let userValidityService: UserValidityServiceInterface
    
    public init(userValidityService: UserValidityServiceInterface) {
        self.userValidityService = userValidityService
    }
    
    public func execute() -> AnyPublisher<Bool, AuthError> {
        return self.userValidityService.isUserValid()
    }
}
