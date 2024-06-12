//
//  SplashViewModel.swift
//  Feelin
//
//  Created by Derrick kim on 6/12/24.
//

import Combine
import Foundation
import DomainOAuthInterface

protocol SplashViewModelInputs {
    func autoLogIn()
}

protocol SplashViewModelOutputs {
    var isSignIn: AnyPublisher<Bool, Never> { get }
}

final class SplashViewModel: SplashViewModelInputs, SplashViewModelOutputs {
    private let autoLogInUseCase: AutoLogInUseCase
    private let isSignInSubject = PassthroughSubject<Bool, Never>()

    private var cancellables = Set<AnyCancellable>()

    var isSignIn: AnyPublisher<Bool, Never> {
        return isSignInSubject.eraseToAnyPublisher()
    }

    init(autoLogInUseCase: AutoLogInUseCase) {
        self.autoLogInUseCase = autoLogInUseCase
    }

    func autoLogIn() {
        autoLogInUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.isSignInSubject.send(false)
                }
            } receiveValue: { [weak self] result in
                self?.isSignInSubject.send(true)
            }
            .store(in: &cancellables)
    }
}
