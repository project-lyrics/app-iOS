//
//  SettingViewModel.swift
//  FeatureMyPageInterface
//
//  Created by 황인우 on 10/13/24.
//

import Foundation
import Combine

import Shared
import Domain

enum LogoutResult {
    case none
    case success
    case failure(UserProfileError)
}

public final class SettingViewModel {
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let logoutUseCase: LogoutUseCaseInterface
    
    @Published var logoutResult: LogoutResult = .none
    
    public init(
        logoutUseCase: LogoutUseCaseInterface
    ) {
        self.logoutUseCase = logoutUseCase
    }
    
    func logout() {
        self.logoutUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.logoutResult = .success
                    
                case .failure(let error):
                    self?.logoutResult = .failure(error)
                    
                }
            }
            .store(in: &cancellables)
    }
}
