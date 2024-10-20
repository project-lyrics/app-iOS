//
//  NotificationAPIService.swift
//  DomainNotification
//
//  Created by 황인우 on 10/5/24.
//

import Core

import Combine
import Foundation
import DomainNotificationInterface

public struct NotificationAPIService: NotificationAPIServiceInterface {
    private let networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func getPersonalNotifications(
        currentPage: Int?,
        numberOfNotifications: Int
    ) -> AnyPublisher<GetNotificationsResponse, NotificationError> {
        let endpoint = FeelinAPI<GetNotificationsResponse>.getPersonalNotifications(
            cursor: currentPage,
            size: numberOfNotifications
        )
        
        return networkProvider.request(endpoint)
            .mapError(NotificationError.init)
            .eraseToAnyPublisher()
    }

    public func getPublicNotifications(currentPage: Int?, numberOfNotifications: Int) -> AnyPublisher<GetNotificationsResponse, NotificationError> {
        let endpoint = FeelinAPI<GetNotificationsResponse>.getPublicNotifications(
            cursor: currentPage,
            size: numberOfNotifications
        )

        return networkProvider.request(endpoint)
            .mapError(NotificationError.init)
            .eraseToAnyPublisher()
    }

    public func checkNotification(notificationID: Int) -> AnyPublisher<FeelinSuccessResponse, NotificationError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.checkNotification(notificationID: notificationID)
        
        return networkProvider.request(endpoint)
            .mapError(NotificationError.init)
            .eraseToAnyPublisher()
    }
    
    public func getHasUncheckedNotification() -> AnyPublisher<UncheckedNotificationResponse, NotificationError> {
        let endpoint = FeelinAPI<UncheckedNotificationResponse>.getHasUncheckedNotification
        
        return networkProvider.request(endpoint)
            .mapError(NotificationError.init)
            .eraseToAnyPublisher()
    }
}
