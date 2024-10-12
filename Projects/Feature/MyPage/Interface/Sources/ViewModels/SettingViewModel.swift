//
//  SettingViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation
import Combine

import Shared
import Domain

public final class SettingViewModel {
    @Published private (set) var fetchedUserInfo: UserProfile?
    @Published private (set) var error: UserProfileError?

    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo

    private let getUserProfileUseCase: GetUserProfileUseCaseInterface

    private var cancellables: Set<AnyCancellable> = .init()

    public init(getUserProfileUseCase: GetUserProfileUseCaseInterface) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }

    public func fetchUserInfo() {
        getUserProfileUseCase.execute()
            .mapToResult()
            .sink { result in
                switch result {
                case .success(let data):
                    self.fetchedUserInfo = data
                case .failure(let error):
                    self.error = error
                }
            }
            .store(in: &cancellables)
    }

    public func removeUser() {
        userInfo = nil
    }
}
