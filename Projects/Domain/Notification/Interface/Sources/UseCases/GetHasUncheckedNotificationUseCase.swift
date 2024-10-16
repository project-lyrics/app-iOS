//
//  GetHasUncheckedNotificationUseCase.swift
//  DomainNotificationInterface
//
//  Created by 황인우 on 10/15/24.
//

import Combine
import Foundation

import Core

public protocol GetHasUncheckedNotificationUseCaseInterface {
    func execute() -> AnyPublisher<Bool, NotificationError>
}

public struct GetHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface {
    private let notificationAPIService: NotificationAPIServiceInterface
    
    public init(notificationAPIService: NotificationAPIServiceInterface) {
        self.notificationAPIService = notificationAPIService
    }
    
    public func execute() -> AnyPublisher<Bool, NotificationError> {
        return notificationAPIService.getHasUncheckedNotification()
            .map(\.hasUnchecked)
            .eraseToAnyPublisher()
    }
}
