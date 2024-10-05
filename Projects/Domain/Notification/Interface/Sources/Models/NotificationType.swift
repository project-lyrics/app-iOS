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
    case report
    case `public`
    
    public init(dto: NotificationTypeResponse) {
        switch dto {
        case .commentOnNote:        self = .commentOnNote
        case .report:               self = .report
        case .public:               self = .public
        }
    }
}
