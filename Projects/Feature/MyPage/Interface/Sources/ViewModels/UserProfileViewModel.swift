//
//  UserProfileViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation
import Combine

import Shared
import Domain

public final class UserProfileViewModel {
    @Published private (set) var fetchedUserProfile: UserProfile?
    @Published private (set) var error: UserProfileError?

    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo

    private let getUserProfileUseCase: GetUserProfileUseCaseInterface

    private var cancellables: Set<AnyCancellable> = .init()

    public init(getUserProfileUseCase: GetUserProfileUseCaseInterface) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }

    public func fetchUserProfile() {
        getUserProfileUseCase.execute()
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let data):
                    self?.fetchedUserProfile = data
                case .failure(let error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}
