//
//  EditUserInfoViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/13/24.
//

import Foundation
import Combine

import Core
import Domain
import UIKit

public final class EditUserInfoViewModel {
    typealias PatchUserProfileResult = Result<FeelinSuccessResponse, UserProfileError>

    public struct Input {
        let birthYearPublisher: AnyPublisher<Int, Never>
        let genderPublisher: AnyPublisher<String, Never>
        let saveButtonTapPublisher: AnyPublisher<UIControl, Never>
    }

    public struct Output {
        let isSaveButtonEnabled: AnyPublisher<Bool, Never>
        let patchUserProfileResult: AnyPublisher<PatchUserProfileResult, Never>
    }

    private let patchUserProfileUseCase: PatchUserProfileUseCaseInterface

    private var cancellables: Set<AnyCancellable> = .init()
    public let userProfile: UserProfile

    public init(
        patchUserProfileUseCase: PatchUserProfileUseCaseInterface,
        model: UserProfile
    ) {
        self.patchUserProfileUseCase = patchUserProfileUseCase
        self.userProfile = model
    }

    func transform(_ input: Input) -> Output {
        let isSaveButtonEnabled = checkSaveButtonIsEnabled(input: input)
        let patchUserInfoResult = patchUserInfo(input: input)

        return Output(
            isSaveButtonEnabled: isSaveButtonEnabled,
            patchUserProfileResult: patchUserInfoResult
        )
    }

    func checkSaveButtonIsEnabled(input: Input) -> AnyPublisher<Bool, Never> {
        return input.birthYearPublisher
            .map { [weak self] birthYear in
                return self?.userProfile.birthYear != birthYear
            }
            .eraseToAnyPublisher()
    }

    func patchUserInfo(input: Input) -> AnyPublisher<PatchUserProfileResult, Never> {
        let combinedUserProfilePublisher = Publishers
            .CombineLatest(
                input.genderPublisher,
                input.birthYearPublisher
            )
            .map { [weak self] (gender, birthYear) -> UserProfileRequestValue in
                let gender = GenderEntity(rawValue: gender)

                return UserProfileRequestValue(
                    gender: gender != self?.userProfile.gender ? gender : nil,
                    birthYear: birthYear != self?.userProfile.birthYear ? birthYear : nil
                )
            }
            .eraseToAnyPublisher()

        return input.saveButtonTapPublisher
            .combineLatest(combinedUserProfilePublisher)
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
