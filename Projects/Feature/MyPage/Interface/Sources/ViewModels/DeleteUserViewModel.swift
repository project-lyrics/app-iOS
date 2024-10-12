//
//  DeleteUserViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import Foundation
import Combine

import Shared
import Domain

public final class DeleteUserViewModel {
    @Published private (set) var error: UserProfileError?

    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo

    private let deleteUserUseCase: DeleteUserUseCaseInterface
    private var cancellables: Set<AnyCancellable> = .init()

    public init(deleteUserUseCase: DeleteUserUseCaseInterface) {
        self.deleteUserUseCase = deleteUserUseCase
    }

    public func deleteUserInfo() {
        deleteUserUseCase.execute()
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.removeUser()
                case .failure(let error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
    public func removeUser() {
        userInfo = nil
    }
}
