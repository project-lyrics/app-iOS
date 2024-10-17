//
//  NotificationType.swift
//  DomainNotificationInterface
//
//  Created by 황인우 on 9/29/24.
//

import Foundation

import Core

public enum NotificationType: Equatable {
    case commentOnNote
    case discipline
    case `public`
    
    public init(dto: NotificationTypeResponse) {
        switch dto {
        case .commentOnNote:        self = .commentOnNote
        case .discipline:           self = .discipline
        case .public:               self = .public
        }
    }
}
