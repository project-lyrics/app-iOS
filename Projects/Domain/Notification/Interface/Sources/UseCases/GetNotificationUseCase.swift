//
//  GetNotificationUseCase.swift
//  DomainNotification
//
//  Created by 황인우 on 10/5/24.
//

import Combine
import Foundation

import Core

public protocol GetNotificationUseCaseInterface {
    func execute(isInitial: Bool, perPage: Int) -> AnyPublisher<[NoteNotification], NotificationError>
}

public struct GetNotificationUseCase: GetNotificationUseCaseInterface {
    private let notificationAPIService: NotificationAPIServiceInterface
    private let notificationPaginationService: NotificationPaginationServiceInterface
    
    public init(
        notificationAPIService: NotificationAPIServiceInterface,
        notificationPaginationService: NotificationPaginationServiceInterface
    ) {
        self.notificationAPIService = notificationAPIService
        self.notificationPaginationService = notificationPaginationService
    }
    
    public func execute(
        isInitial: Bool,
        perPage: Int
    ) -> AnyPublisher<[NoteNotification], NotificationError> {
        if notificationPaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        if isInitial {
            self.notificationPaginationService.update(
                currentPage: nil,
                hasNextPage: true
            )
        }
        
        guard notificationPaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        notificationPaginationService.setLoading(true)
        
        return notificationAPIService.getNotifications(
            currentPage: notificationPaginationService.currentPage,
            numberOfNotifications: perPage
        )
        .receive(on: DispatchQueue.main)
        .map({ [weak notificationPaginationService] getNotificationsResponse -> [NoteNotification] in
            notificationPaginationService?.update(
                currentPage: getNotificationsResponse.nextCursor,
                hasNextPage: getNotificationsResponse.hasNext
            )
            notificationPaginationService?.setLoading(false)
            
            return getNotificationsResponse.data.map(NoteNotification.init)
        })
        .catch { [weak notificationPaginationService] error -> AnyPublisher<[NoteNotification], NotificationError> in
            notificationPaginationService?.setLoading(false)
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
