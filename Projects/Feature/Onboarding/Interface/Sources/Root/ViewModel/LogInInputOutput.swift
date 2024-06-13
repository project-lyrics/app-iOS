//
//  LogInInputOutput.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 6/9/24.
//

import Combine
import DomainOAuthInterface

public protocol LogInViewModelInputs {
    func kakaoLogin()
    func appleLogIn()
    func fetchRecentLogInRecord()
}

public protocol LogInViewModelOutputs {
    var loginSuccess: AnyPublisher<Bool, Never> { get }
    var loginFailure: AnyPublisher<Error, Never> { get }
    var recentLogInRecord: AnyPublisher<OAuthType, Never> { get }
}
