//
//  NotificationAPIServiceInterface.swift
//  DomainNotificationInterface
//
//  Created by Derrick kim on 10/20/24.
//

import Core

import Combine
import Foundation

public protocol NotificationAPIServiceInterface {
    func getPersonalNotifications(currentPage: Int?, numberOfNotifications: Int) -> AnyPublisher<GetNotificationsResponse, NotificationError>
    func getPublicNotifications(currentPage: Int?, numberOfNotifications: Int) -> AnyPublisher<GetNotificationsResponse, NotificationError>
    func checkNotification(notificationID: Int) -> AnyPublisher<FeelinSuccessResponse, NotificationError>
    func getHasUncheckedNotification() -> AnyPublisher<UncheckedNotificationResponse, NotificationError>
}
