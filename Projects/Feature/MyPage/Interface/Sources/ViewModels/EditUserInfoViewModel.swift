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
        let isEnabledSaveButton = isEnabledSaveButton(input: input)
        let patchUserInfoResult = patchUserInfo(input: input)

        return Output(
            isSaveButtonEnabled: isEnabledSaveButton,
            patchUserProfileResult: patchUserInfoResult
        )
    }
}

private extension EditUserInfoViewModel {
    func isEnabledSaveButton(_ birthYear: Int?, _ genderType: String?) -> Bool {
        return (birthYear?.description.isEmpty == false && birthYear != self.userProfile.birthYear) || (genderType?.isEmpty == false && genderType != self.userProfile.gender?.rawValue)
    }

    func isEnabledSaveButton(input: Input) -> AnyPublisher<Bool, Never> {
        let birthYearStream = input.birthYearPublisher
            .map { birthYear in
                return self.isEnabledSaveButton(birthYear, self.userProfile.gender?.rawValue)
            }

        let genderStream = input.genderPublisher
            .map { gender in
                return self.isEnabledSaveButton(self.userProfile.birthYear, gender)
            }

        return Publishers.Merge(birthYearStream, genderStream)
            .eraseToAnyPublisher()
    }

    func patchUserInfo(input: Input) -> AnyPublisher<PatchUserProfileResult, Never> {
        let initialValue = UserProfileRequestValue(gender: nil, birthYear: nil)

        let birthYearStream = input.birthYearPublisher
            .map { birthYear -> UserProfileRequestValue in
                UserProfileRequestValue(
                    gender: nil,
                    birthYear: birthYear != self.userProfile.birthYear ? birthYear : nil
                )
            }

        let genderStream = input.genderPublisher
            .map { gender -> UserProfileRequestValue in
                let genderEntity = GenderEntity(rawValue: gender)
                return UserProfileRequestValue(
                    gender: genderEntity != self.userProfile.gender ? genderEntity : nil,
                    birthYear: nil
                )
            }

        let combinedUserProfilePublisher = Publishers
            .Merge(birthYearStream, genderStream)
            .scan(initialValue) { accumulated, new in
                UserProfileRequestValue(
                    gender: new.gender ?? accumulated.gender,
                    birthYear: new.birthYear ?? accumulated.birthYear
                )
            }
            .filter { requestValue in
                return requestValue.gender != nil || requestValue.birthYear != nil
            }
            .removeDuplicates()
            .eraseToAnyPublisher()

        return input.saveButtonTapPublisher
            .combineLatest(combinedUserProfilePublisher)
            .flatMap { [weak self] (_, value) -> AnyPublisher<PatchUserProfileResult, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }

                return self.patchUserInfo(value)
                    .handleEvents(receiveOutput: { result in
                        if case .success = result {
                            // 성공한 경우엔 초기화 없이 그대로 둡니다.
                        }
                    })
                    .mapError { _ in UserProfileError.unknown(errorDescription: "") }
                    .catch { error -> AnyPublisher<PatchUserProfileResult, Never> in
                        // 실패한 경우에만 유지하여 재시도 가능하게
                        return Just(.failure(error)).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
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
