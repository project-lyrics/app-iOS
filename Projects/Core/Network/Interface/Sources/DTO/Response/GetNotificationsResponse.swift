//
//  GetNotificationsResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 10/5/24.
//

import Foundation

public enum NotificationTypeResponse: String, Decodable {
    case commentOnNote = "COMMENT_ON_NOTE"
    case discipline = "DISCIPLINE"
    case `public` = "PUBLIC"
}

public struct NotificationResponse: Decodable {
    public let id: Int
    public let type: NotificationTypeResponse
    public let content: String?
    public let checked: Bool
    public let noteId: Int?
    public let noteContent: String?
    public let artistImageUrl: String?
    public let createdAt: Date
    
    public init(
        id: Int,
        type: NotificationTypeResponse,
        content: String?,
        checked: Bool,
        noteId: Int?,
        noteContent: String?,
        artistImageUrl: String?,
        createdAt: Date
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.checked = checked
        self.noteId = noteId
        self.noteContent = noteContent
        self.artistImageUrl = artistImageUrl
        self.createdAt = createdAt
    }
}

public struct GetNotificationsResponse: Decodable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let data: [NotificationResponse]
    
    public init(
        nextCursor: Int,
        hasNext: Bool,
        data: [NotificationResponse]
    ) {
        self.nextCursor = nextCursor
        self.hasNext = hasNext
        self.data = data
    }
}
