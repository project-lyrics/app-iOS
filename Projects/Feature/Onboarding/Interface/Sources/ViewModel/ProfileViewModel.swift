//
//  ProfileViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 7/18/24.
//

import Combine
import Domain
import Foundation

public final class ProfileViewModel {
    public struct Input {
        let combinedSignUpModelPublisher: AnyPublisher<UserSignUpEntity, Never>
    }

    public struct Output {
        let signUpResult: AnyPublisher<SignUpResult, Never>
    }

    private let signUpUseCase: SignUpUseCase
    private var userSignUpEntity: UserSignUpEntity

    public init(
        userSignUpEntity: UserSignUpEntity,
        signUpUseCase: SignUpUseCase
    ) {
        self.userSignUpEntity = userSignUpEntity
        self.signUpUseCase = signUpUseCase
    }

    func transform(_ input: Input) -> Output {
        return Output(
            signUpResult: self.signUp(input: input)
        )
    }
}

private extension ProfileViewModel {
    func signUp(input: Input) -> AnyPublisher<SignUpResult, Never> {
        return input.combinedSignUpModelPublisher
            .handleEvents(receiveOutput: { [weak self] entity in
                self?.userSignUpEntity.nickname = entity.nickname
                self?.userSignUpEntity.profileCharacter = entity.profileCharacter
            })
            .flatMap { [weak self] _ -> AnyPublisher<SignUpResult, Never> in
                guard let self else {
                    return Just(SignUpResult.failure(.unExpectedError)).eraseToAnyPublisher()
                }

                return self.signUp(userSignUpEntity)
            }
            .eraseToAnyPublisher()
    }

    private func signUp(_ model: UserSignUpEntity) -> AnyPublisher<SignUpResult, Never> {
        return self.signUpUseCase.execute(model: model)
            .catch { error -> AnyPublisher<SignUpResult, Never> in
                return Just(SignUpResult.failure(error)).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
