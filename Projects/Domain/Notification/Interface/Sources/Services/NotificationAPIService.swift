//
//  NotificationAPIService.swift
//  DomainNotification
//
//  Created by 황인우 on 10/5/24.
//

import Core

import Combine
import Foundation

public protocol NotificationAPIServiceInterface {
    func getNotifications(currentPage: Int?, numberOfNotifications: Int) -> AnyPublisher<GetNotificationsResponse, NotificationError>
    func checkNotification(notificationID: Int) -> AnyPublisher<FeelinSuccessResponse, NotificationError>
}

public struct NotificationAPIService: NotificationAPIServiceInterface {
    private let networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func getNotifications(
        currentPage: Int?,
        numberOfNotifications: Int
    ) -> AnyPublisher<GetNotificationsResponse, NotificationError> {
        let endpoint = FeelinAPI<GetNotificationsResponse>.getNotifications(
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
    
    
}
