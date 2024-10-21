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
    @Published private (set) var deleteUserResult: DeleteUserResult = .none

    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo

    private let deleteUserUseCase: DeleteUserUseCaseInterface
    private var cancellables: Set<AnyCancellable> = .init()

    public init(deleteUserUseCase: DeleteUserUseCaseInterface) {
        self.deleteUserUseCase = deleteUserUseCase
    }

    public func deleteUserInfo() {
        deleteUserUseCase.execute()
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.deleteUserResult = .success
                case .failure(let error):
                    self?.deleteUserResult = .failure(error)
                }
            }
            .store(in: &cancellables)
    }
}
