//
//  SplashViewModel.swift
//  Feelin
//
//  Created by Derrick kim on 6/12/24.
//

import Combine
import Foundation
import DomainOAuthInterface
import Shared

protocol SplashViewModelInputs {
    func autoLogin()
}

protocol SplashViewModelOutputs {
    var isSignIn: AnyPublisher<Bool, Never> { get }
    var feelinAPIError: AnyPublisher<FeelinAPIError, Never> { get }
}

final class SplashViewModel: SplashViewModelInputs, SplashViewModelOutputs {
    private let autoLoginUseCase: AutoLoginUseCase
    private let isSignInSubject = PassthroughSubject<Bool, Never>()
    private let feelinAPIErrorSubject: PassthroughSubject<FeelinAPIError, Never> = .init()

    private var cancellables = Set<AnyCancellable>()

    var isSignIn: AnyPublisher<Bool, Never> {
        return isSignInSubject
            .eraseToAnyPublisher()
    }
    
    var feelinAPIError: AnyPublisher<FeelinAPIError, Never> {
        return feelinAPIErrorSubject.eraseToAnyPublisher()
    }

    init(autoLoginUseCase: AutoLoginUseCase) {
        self.autoLoginUseCase = autoLoginUseCase
    }

    func autoLogin() {
        autoLoginUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if case .feelinAPIError(let feelinAPIError) = error {
                        self?.feelinAPIErrorSubject.send(feelinAPIError)
                    } else {
                        self?.isSignInSubject.send(false)
                    }
                }
            } receiveValue: { [weak self] result in
                self?.isSignInSubject.send(true)
            }
            .store(in: &cancellables)
    }
}
