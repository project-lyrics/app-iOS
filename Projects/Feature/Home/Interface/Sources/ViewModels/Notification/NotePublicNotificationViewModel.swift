//
//  NotePublicNotificationViewModel.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 10/20/24.
//

import Combine
import Foundation

import Domain

public final class NotePublicNotificationViewModel {
    @Published private (set) var fetchedPublicNotifications: [NoteNotification] = []
    @Published private (set) var error: NotificationError?
    @Published private (set) var refreshState: RefreshState<NotificationError> = .idle

    private var cancellables: Set<AnyCancellable> = .init()

    private let checkNotificationUseCase: CheckNotificationUseCaseInterface
    private let getPublicNotificationUseCase: GetNotificationUseCaseInterface

    public init(
        checkNotificationUseCase: CheckNotificationUseCaseInterface,
        getPublicNotificationUseCase: GetNotificationUseCaseInterface
    ) {
        self.checkNotificationUseCase = checkNotificationUseCase
        self.getPublicNotificationUseCase = getPublicNotificationUseCase
    }

    func getPublicNotification(
        isInitial: Bool,
        perPage: Int = 10
    ) {
        self.getPublicNotificationUseCase.execute(
            isInitial: isInitial,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let notifications):
                if isInitial {
                    self?.fetchedPublicNotifications = notifications
                } else {
                    self?.fetchedPublicNotifications.append(contentsOf: notifications)
                }
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }

    func refreshNotifications(perPage: Int = 10) {
        self.refreshState = .refreshing

        self.getPublicNotificationUseCase.execute(
            isInitial: true,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let notifications):
                self?.fetchedPublicNotifications = notifications
                self?.refreshState = .completed
            case .failure(let error):
                self?.refreshState = .failed(error)
            }
        }
        .store(in: &cancellables)
    }

    func checkNotification(at index: Int) {
        let selectedNotification = self.fetchedPublicNotifications[index]

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

