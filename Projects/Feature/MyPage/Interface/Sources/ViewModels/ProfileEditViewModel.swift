//
//  ProfileEditViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import Combine
import UIKit

import SharedDesignSystem
import Domain
import Core

public final class ProfileEditViewModel {
    typealias PatchUserProfileResult = Result<FeelinSuccessResponse, UserProfileError>

    public struct Input {
        let nicknameTextPublisher: AnyPublisher<String?, Never>
        let profileImagePublisher: AnyPublisher<String, Never>
        let saveButtonTapPublisher: AnyPublisher<UIControl, Never>
    }

    public struct Output {
        let isSaveButtonEnabled: AnyPublisher<Bool, Never>
        let profileImage: AnyPublisher<UIImage?, Never>
        let patchUserProfileResult: AnyPublisher<PatchUserProfileResult, Never>
    }

    private let patchUserProfileUseCase: PatchUserProfileUseCaseInterface
    let userProfile: UserProfile
    private var cancellables = Set<AnyCancellable>()

    public init(
        patchUserProfileUseCase: PatchUserProfileUseCaseInterface,
        userProfile: UserProfile
    ) {
        self.patchUserProfileUseCase = patchUserProfileUseCase
        self.userProfile = userProfile
    }

    func transform(_ input: Input) -> Output {
        let isSaveButtonEnabled = checkSaveButtonIsEnabled(input: input)
        let profileImage = convertProfileImage(input: input)
        let patchUserInfoResult = patchUserInfo(input: input)

        return Output(
            isSaveButtonEnabled: isSaveButtonEnabled,
            profileImage: profileImage,
            patchUserProfileResult: patchUserInfoResult
        )
    }
}

private extension ProfileEditViewModel {
    func isEnabledSaveButton(_ nickname: String?) -> Bool {
        let count = nickname?.count ?? 0
        return nickname?.isEmpty == false && count < 10
    }

    func checkSaveButtonIsEnabled(input: Input) -> AnyPublisher<Bool, Never> {
        return input.nicknameTextPublisher
            .map { nickname in
                return self.isEnabledSaveButton(nickname)
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

    func patchUserInfo(input: Input) -> AnyPublisher<PatchUserProfileResult, Never> {
        let validNicknamePublisher = input.nicknameTextPublisher
            .filter { nickname in return self.isEnabledSaveButton(nickname) }
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let combinedUserProfileModelPublisher = Publishers
            .CombineLatest(
                validNicknamePublisher,
                input.profileImagePublisher
            )
            .map { (nickname, profileCharacter) -> UserProfileRequestValue in
                let type = ProfileCharacterType(rawValue: profileCharacter) ?? .braidedHair
                return UserProfileRequestValue(
                    nickname: nickname,
                    profileCharacter: type,
                    gender: self.userProfile.gender,
                    birthYear: self.userProfile.birthYear
                )
            }
            .eraseToAnyPublisher()

        return input.saveButtonTapPublisher
            .combineLatest(combinedUserProfileModelPublisher)
            .flatMap { [weak self]  (_, value) -> AnyPublisher<PatchUserProfileResult, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.patchUserInfo(value)
            }
            .eraseToAnyPublisher()
    }

    func patchUserInfo(_ value: UserProfileRequestValue) -> AnyPublisher<PatchUserProfileResult, Never> {
        return self.patchUserProfileUseCase
            .execute(requestValue: value)
            .receive(on: DispatchQueue.main)
            .mapToResult()
    }
}
