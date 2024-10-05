//
//  NoteNotification.swift
//  DomainNotificationInterface
//
//  Created by 황인우 on 9/29/24.
//

import Core

import Foundation

public struct NoteNotification: Hashable {
    private let uuid: UUID = .init()
    
    public let id: Int
    public let type: NotificationType
    public let image: String?
    public var hasRead: Bool
    public let content: String
    public let time: Date
    
    public init(
        id: Int,
        type: NotificationType,
        image: String?,
        hasRead: Bool,
        content: String,
        time: Date
    ) {
        self.id = id
        self.type = type
        self.image = image
        self.hasRead = hasRead
        self.content = content
        self.time = time
    }
    
    public init(dto: NotificationResponse) {
        self.id = dto.id
        self.type = NotificationType(dto: dto.type)
        self.image = dto.artistImageUrl
        self.hasRead = dto.checked
        if dto.type == .public {
            self.content = dto.content
        } else {
            self.content = dto.noteContent
        }
        self.time = dto.createdAt
    }
}
