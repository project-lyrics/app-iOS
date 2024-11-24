//
//  BlockedUsersViewModel.swift
//  FeatureMyPageInterface
//
//  Created by 황인우 on 11/23/24.
//

import Combine
import UIKit

import Domain
import Shared

public final class BlockedUsersViewModel {
    @Published private (set) var fetchedUsers: [User] = []
    @Published private (set) var error: UserProfileError?
    @Published private (set) var unblockUserResult: UnblockUserResult<UserProfileError> = .none
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let blockUserUseCase: BlockUserUseCaseInterface
    private let fetchBlockedUsersUseCase: FetchBlockedUsersUseCaseInterface
    
    public init(
        blockUserUseCase: BlockUserUseCaseInterface,
        fetchBlockedUsersUseCase: FetchBlockedUsersUseCaseInterface
    ) {
        self.blockUserUseCase = blockUserUseCase
        self.fetchBlockedUsersUseCase = fetchBlockedUsersUseCase
    }
    
    func fetchBlockedUsers() {
        self.fetchBlockedUsersUseCase.execute()
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let users):
                    self?.fetchedUsers = users
                    
                case .failure(let error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
    
    func unblockUser(id: Int) {
        self.blockUserUseCase.execute(
            shouldBlock: false,
            userID: id
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success:
                self?.unblockUserResult = .success
                self?.fetchedUsers.removeAll(where: { $0.id == id })
                
            case .failure(let error):
                self?.unblockUserResult = .failure(error)
            }
        }
        .store(in: &cancellables)
    }
}
