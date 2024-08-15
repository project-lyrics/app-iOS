//
//  ProfileViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 7/18/24.
//

import Combine
import Domain
import UIKit
import SharedDesignSystem

public final class ProfileViewModel {
    public struct Input {
        let nicknameTextPublisher: AnyPublisher<String?, Never>
        let profileImagePublisher: AnyPublisher<String, Never>
        let nextButtonTapPublisher: AnyPublisher<UIControl, Never>
    }

    public struct Output {
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
        let profileImage: AnyPublisher<UIImage?, Never>
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
            isNextButtonEnabled: self.checkNextButtonIsEnabled(input: input),
            profileImage: self.convertProfileImage(input: input),
            signUpResult: self.signUp(input: input)
        )
    }
}

private extension ProfileViewModel {
    func isEnabledNextButton(_ nickname: String?) -> Bool {
        guard let nickname = nickname, !nickname.isEmpty, nickname.count < 10 else {
            return false
        }
        return true
    }

    func checkNextButtonIsEnabled(input: Input) -> AnyPublisher<Bool, Never> {
        return input.nicknameTextPublisher
            .map { nickname in
                return self.isEnabledNextButton(nickname)
            }
            .eraseToAnyPublisher()
    }

    func convertProfileImage(input: Input) -> AnyPublisher<UIImage?, Never> {
        input.profileImagePublisher
            .map { profileCharacter in
                let image = ProfileCharacterType(rawValue: profileCharacter)?.image
                return image
            }
            .eraseToAnyPublisher()
    }

    func signUp(input: Input) -> AnyPublisher<SignUpResult, Never> {
        let validNicknamePublisher = input.nicknameTextPublisher
            .filter { nickname in return self.isEnabledNextButton(nickname) }
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let combinedSignUpModelPublisher = Publishers
            .CombineLatest(
                validNicknamePublisher,
                input.profileImagePublisher
            )
            .map { (nickname, profileCharacter) -> UserSignUpEntity in
                var entity = self.userSignUpEntity
                entity.nickname = nickname
                entity.profileCharacter = profileCharacter
                return entity
            }
            .eraseToAnyPublisher()

        return input.nextButtonTapPublisher
            .combineLatest(combinedSignUpModelPublisher)
            .flatMap { (_, entity) in
                return self.signUp(entity)
            }
            .eraseToAnyPublisher()
    }

    func signUp(_ model: UserSignUpEntity) -> AnyPublisher<SignUpResult, Never> {
        return self.signUpUseCase.execute(model: model)
            .catch { error -> AnyPublisher<SignUpResult, Never> in
                return Just(SignUpResult.failure(error)).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
