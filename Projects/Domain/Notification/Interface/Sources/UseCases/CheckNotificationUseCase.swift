//
//  CheckNotificationUseCase.swift
//  DomainNotification
//
//  Created by 황인우 on 10/5/24.
//

import Combine
import Foundation

import Core

public protocol CheckNotificationUseCaseInterface {
    func execute(notificationID: Int) -> AnyPublisher<Bool, NotificationError>
}

public struct CheckNotificationUseCase: CheckNotificationUseCaseInterface {
    private let notificationAPIService: NotificationAPIServiceInterface
    
    public init(notificationAPIService: NotificationAPIServiceInterface) {
        self.notificationAPIService = notificationAPIService
    }
    
    public func execute(notificationID: Int) -> AnyPublisher<Bool, NotificationError> {
        return notificationAPIService.checkNotification(notificationID: notificationID)
            .map(\.success)
            .eraseToAnyPublisher()
    }
}
