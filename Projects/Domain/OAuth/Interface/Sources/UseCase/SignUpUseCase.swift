//
//  SignUpUseCase.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/18/24.
//

import Combine
import Foundation

public struct SignUpUseCase {
    private let signUpService: SignUpServiceInterface

    public init(signUpService: SignUpServiceInterface) {
        self.signUpService = signUpService
    }

    public func execute(model: UserSignUpEntity) -> AnyPublisher<SignUpResult, SignUpError> {
        return signUpService.signUp(model)
    }
}
