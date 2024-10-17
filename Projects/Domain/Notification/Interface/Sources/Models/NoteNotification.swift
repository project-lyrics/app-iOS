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
    public let content: String?
    public let noteID: Int?
    public let time: Date
    
    public init(
        id: Int,
        type: NotificationType,
        image: String?,
        hasRead: Bool,
        content: String,
        noteID: Int,
        time: Date
    ) {
        self.id = id
        self.type = type
        self.image = image
        self.hasRead = hasRead
        self.content = content
        self.noteID = noteID
        self.time = time
    }

    public init(dto: NotificationResponse) {
        self.id = dto.id
        self.type = NotificationType(dto: dto.type)
        self.image = dto.artistImageUrl
        self.hasRead = dto.checked
        
        // .commentsOnNote일 경우 noteContent != nil, content == nil
        // .public, .discipline일 경우 content != nil, noteContent == nil, noteID == nil, image == nil
        if dto.type == .commentOnNote {
            self.content = dto.noteContent
        } else {
            self.content = dto.noteContent
        }

        self.noteID = dto.noteId
        self.time = dto.createdAt
    }
}

extension NoteNotification {
    public static let mockData = [
        NoteNotification(id: 1, type: .commentOnNote, image: "https://artist.image.com/1", hasRead: false, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 2, type: .discipline, image: "https://artist.image.com/2", hasRead: true, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 3, type: .discipline, image: "https://artist.image.com/3", hasRead: false, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 4, type: .commentOnNote, image: "https://artist.image.com/4", hasRead: true, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 5, type: .commentOnNote, image: "https://artist.image.com/5", hasRead: false, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 6, type: .commentOnNote, image: "https://artist.image.com/6", hasRead: true, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 7, type: .commentOnNote, image: "https://artist.image.com/7", hasRead: false, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 8, type: .commentOnNote, image: "https://artist.image.com/8", hasRead: true, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 9, type: .commentOnNote, image: "https://artist.image.com/9", hasRead: false, content: "notification content", noteID: 1, time: Date()),
        NoteNotification(id: 10, type: .commentOnNote, image: "https://artist.image.com/10", hasRead: true, content: "notification content", noteID: 1, time: Date())
    ]
}
