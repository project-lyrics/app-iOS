//
//  NoteNotificationViewModel.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/29/24.
//

import Combine
import Foundation

import Domain

public final class NoteNotificationViewModel {
    @Published private (set) var fetchedNotifications: [NoteNotification] = []
    @Published private (set) var error: NotificationError?
    @Published private (set) var refreshState: RefreshState<NotificationError> = .idle
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let checkNotificationUseCase: CheckNotificationUseCaseInterface
    private let getNotificationUseCase: GetNotificationUseCaseInterface
    
    public init(
        checkNotificationUseCase: CheckNotificationUseCaseInterface,
        getNotificationUseCase: GetNotificationUseCaseInterface
    ) {
        self.checkNotificationUseCase = checkNotificationUseCase
        self.getNotificationUseCase = getNotificationUseCase
    }
    
    func getNotifications(
        isInitial: Bool,
        perPage: Int = 10
    ) {
        self.getNotificationUseCase.execute(
            isInitial: isInitial,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let notifications):
                if isInitial {
                    self?.fetchedNotifications = notifications
                } else {
                    self?.fetchedNotifications.append(contentsOf: notifications)
                }
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
    
    func refreshNotifications(perPage: Int = 10) {
        self.refreshState = .refreshing
        
        self.getNotificationUseCase.execute(
            isInitial: true,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let notifications):
                self?.fetchedNotifications = notifications
                self?.refreshState = .completed
            case .failure(let error):
                self?.refreshState = .failed(error)
            }
        }
        .store(in: &cancellables)
    }
    
    func checkNotification(at index: Int) {
        let selectedNotification = self.fetchedNotifications[index]
        
        self.checkNotificationUseCase.execute(notificationID: selectedNotification.id)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let isSuccess):
                    return
                    
                case .failure(let error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}
