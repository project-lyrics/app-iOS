//
//  MyPageViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/10/24.
//

import Foundation
import Combine

import Domain

public final class MyPageViewModel {
    @Published private (set) var fetchedUserProfile: UserProfile?
    @Published private (set) var error: UserProfileError?

    private let getUserProfileUseCase: GetUserProfileUseCaseInterface
    private var cancellables: Set<AnyCancellable> = .init()

    public init(getUserProfileUseCase: GetUserProfileUseCaseInterface) {
        self.getUserProfileUseCase = getUserProfileUseCase
    }

    public func fetchUserProfile() {
        getUserProfileUseCase.execute()
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
