//
//  LoginViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 6/8/24.
//

import Combine
import DomainOAuthInterface
import Foundation

public final class LoginViewModel {
    public var inputs: LoginViewModelInputs { return self }
    public var outputs: LoginViewModelOutputs { return self }

    private var cancellables = Set<AnyCancellable>()
    private let loginSuccessSubject = PassthroughSubject<Bool, Never>()
    private let loginFailureSubject = PassthroughSubject<Error, Never>()
    private let recentLoginRecordSubject = PassthroughSubject<OAuthType, Never>()

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
}

extension LoginViewModel: LoginViewModelInputs, LoginViewModelOutputs {
    public var recentLoginRecord: AnyPublisher<OAuthType, Never> {
        return recentLoginRecordSubject.eraseToAnyPublisher()
    }

    public var loginSuccess: AnyPublisher<Bool, Never> {
        return loginSuccessSubject.eraseToAnyPublisher()
    }

    public var loginFailure: AnyPublisher<Error, Never> {
        return loginFailureSubject.eraseToAnyPublisher()
    }

    public func kakaoLogin() {
        kakaoOAuthLoginUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.loginFailureSubject.send(error)
                }
            } receiveValue: { [weak self] result in
                self?.saveLoginRecord(oAuthType: result.oAuthType.rawValue)
                self?.loginSuccessSubject.send(true)
            }
            .store(in: &cancellables)
    }

    public func appleLogin() {
        appleOAuthLoginUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.loginFailureSubject.send(error)
                }
            } receiveValue: { [weak self] result in
                self?.saveLoginRecord(oAuthType: result.oAuthType.rawValue)
                self?.loginSuccessSubject.send(true)
            }
            .store(in: &cancellables)
    }

    public func fetchRecentLoginRecord() {
        recentLoginRecordService.getRecentLoginRecord()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { [weak self] type in
                self?.recentLoginRecordSubject.send(type)
            }
            .store(in: &cancellables)
    }
}


private extension LoginViewModel {
    func saveLoginRecord(oAuthType: String) {
        recentLoginRecordService.save(oAuthType: oAuthType)
    }
}
