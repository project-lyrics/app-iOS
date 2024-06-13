//
//  LogInViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 6/8/24.
//

import Combine
import DomainOAuthInterface
import Foundation

public final class LogInViewModel {
    public var inputs: LogInViewModelInputs { return self }
    public var outputs: LogInViewModelOutputs { return self }

    private var cancellables = Set<AnyCancellable>()
    private let logInSuccessSubject = PassthroughSubject<Bool, Never>()
    private let logInFailureSubject = PassthroughSubject<Error, Never>()
    private let recentLogInRecordSubject = PassthroughSubject<OAuthType, Never>()

    private let kakaoOAuthLoginUseCase: OAuthLogInUseCase
    private let appleOAuthLoginUseCase: OAuthLogInUseCase
    private let recentLogInRecordService: RecentLogInRecordServiceInterface

    public init(
        kakaoOAuthLoginUseCase: OAuthLogInUseCase,
        appleOAuthLoginUseCase: OAuthLogInUseCase,
        recentLoginRecordService: RecentLogInRecordServiceInterface
    ) {
        self.kakaoOAuthLoginUseCase = kakaoOAuthLoginUseCase
        self.appleOAuthLoginUseCase = appleOAuthLoginUseCase
        self.recentLogInRecordService = recentLoginRecordService
    }
}

extension LogInViewModel: LogInViewModelInputs, LogInViewModelOutputs {
    public var recentLogInRecord: AnyPublisher<OAuthType, Never> {
        return recentLogInRecordSubject.eraseToAnyPublisher()
    }

    public var loginSuccess: AnyPublisher<Bool, Never> {
        return logInSuccessSubject.eraseToAnyPublisher()
    }

    public var loginFailure: AnyPublisher<Error, Never> {
        return logInFailureSubject.eraseToAnyPublisher()
    }

    public func kakaoLogin() {
        kakaoOAuthLoginUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.logInFailureSubject.send(error)
                }
            } receiveValue: { [weak self] result in
                self?.saveLogInRecord(oAuthType: result.oAuthType.rawValue)
                self?.logInSuccessSubject.send(true)
            }
            .store(in: &cancellables)
    }

    public func appleLogIn() {
        appleOAuthLoginUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.logInFailureSubject.send(error)
                }
            } receiveValue: { [weak self] result in
                self?.saveLogInRecord(oAuthType: result.oAuthType.rawValue)
                self?.logInSuccessSubject.send(true)
            }
            .store(in: &cancellables)
    }

    public func fetchRecentLogInRecord() {
        recentLogInRecordService.getRecentLogInRecord()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { [weak self] type in
                self?.recentLogInRecordSubject.send(type)
            }
            .store(in: &cancellables)
    }
}


private extension LogInViewModel {
    func saveLogInRecord(oAuthType: String) {
        recentLogInRecordService.save(oAuthType: oAuthType)
    }
}
