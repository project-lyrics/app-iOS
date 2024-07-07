//
//  LoginViewModel.swift
//  FeatureOnboarding
//
//  Created by Derrick kim on 7/3/24.
//

import Combine
import DomainOAuthInterface
import Foundation

public final class LoginViewModel {
    public struct Input {
        let loginButtonTappedPublisher: AnyPublisher<OAuthType, Never>
        let recentLoginPublisher: AnyPublisher<Void, Never>
    }

    public struct Output {
        let loginResult: AnyPublisher<OAuthResult, Never>
        let recentLoginResult: AnyPublisher<OAuthType, Never>
    }
    private let kakaoOAuthLoginUseCase: OAuthLoginUseCase
    private let appleOAuthLoginUseCase: OAuthLoginUseCase
    private let recentLoginRecordService: RecentLoginRecordServiceInterface
    public init(
        kakaoOAuthLoginUseCase: OAuthLoginUseCase,
        appleOAuthLoginUseCase: OAuthLoginUseCase,
        recentLoginRecordService: RecentLoginRecordServiceInterface
    ) {
        self.kakaoOAuthLoginUseCase = kakaoOAuthLoginUseCase
        self.appleOAuthLoginUseCase = appleOAuthLoginUseCase
        self.recentLoginRecordService = recentLoginRecordService
    }

    func transform(_ input: Input) -> Output {
        return Output(
            loginResult: self.login(input: input),
            recentLoginResult: self.getRecentLoginRecord(input: input)
        )
    }
}

extension LoginViewModel {
    private func login(input: Input) -> AnyPublisher<OAuthResult, Never> {
        return input.loginButtonTappedPublisher
            .flatMap { [unowned self] type -> AnyPublisher<OAuthResult, Never> in
                switch type {
                case .apple:    return self.appleLogin()
                case .kakao:    return self.kakaoLogin()
                default:        return Just(OAuthResult.success(.none)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func kakaoLogin() -> AnyPublisher<OAuthResult, Never> {
        return self.kakaoOAuthLoginUseCase.execute()
            .catch { error -> AnyPublisher<OAuthResult, Never> in
                return Just(OAuthResult.failure(error.errorDescription ?? "")).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func appleLogin() -> AnyPublisher<OAuthResult, Never> {
        return self.appleOAuthLoginUseCase.execute()
            .catch { error -> AnyPublisher<OAuthResult, Never> in
                return Just(OAuthResult.failure(error.errorDescription ?? "")).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    public func getRecentLoginRecord(input: Input) -> AnyPublisher<OAuthType, Never> {
        input.recentLoginPublisher
            .flatMap { [weak self] () -> AnyPublisher<OAuthType, Never> in
                guard let self = self else {
                    return Just(OAuthType.none).eraseToAnyPublisher()
                }

                return recentLoginRecordService.getRecentLoginRecord()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
