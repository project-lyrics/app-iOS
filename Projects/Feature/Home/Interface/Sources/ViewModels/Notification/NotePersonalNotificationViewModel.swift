//
//  NotePersonalNotificationViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/29/24.
//

import Combine
import Foundation

import Domain

public final class NotePersonalNotificationViewModel {
    @Published private (set) var fetchedPersonalNotifications: [NoteNotification] = []
    @Published private (set) var error: NotificationError?
    @Published private (set) var refreshState: RefreshState<NotificationError> = .idle
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let checkNotificationUseCase: CheckNotificationUseCaseInterface
    private let getPersonalNotificationUseCase: GetNotificationUseCaseInterface

    public init(
        checkNotificationUseCase: CheckNotificationUseCaseInterface,
        getPersonalNotificationUseCase: GetNotificationUseCaseInterface
    ) {
        self.checkNotificationUseCase = checkNotificationUseCase
        self.getPersonalNotificationUseCase = getPersonalNotificationUseCase
    }
    
    func getNotifications(
        isInitial: Bool,
        perPage: Int = 10
    ) {
        self.getPersonalNotificationUseCase.execute(
            isInitial: isInitial,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let notifications):
                if isInitial {
                    self?.fetchedPersonalNotifications = notifications
                } else {
                    self?.fetchedPersonalNotifications.append(contentsOf: notifications)
                }
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
    
    func refreshNotifications(perPage: Int = 10) {
        self.refreshState = .refreshing
        
        self.getPersonalNotificationUseCase.execute(
            isInitial: true,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let notifications):
                self?.fetchedPersonalNotifications = notifications
                self?.refreshState = .completed
            case .failure(let error):
                self?.refreshState = .failed(error)
            }
        }
        .store(in: &cancellables)
    }
    
    func checkNotification(at index: Int) {
        let selectedNotification = self.fetchedPersonalNotifications[index]
        
        self.checkNotificationUseCase.execute(notificationID: selectedNotification.id)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success:
                    return
                    
                case .failure(let error):
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}
