//
//  LoginInputOutput.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 6/9/24.
//

import Combine
import DomainOAuthInterface

public protocol LoginViewModelInputs {
    func kakaoLogin()
    func appleLogin()
    func fetchRecentLoginRecord()
}

public protocol LoginViewModelOutputs {
    var loginSuccess: AnyPublisher<Bool, Never> { get }
    var loginFailure: AnyPublisher<Error, Never> { get }
    var recentLoginRecord: AnyPublisher<OAuthType, Never> { get }
}
