//
//  Note.swift
//  DomainNote
//
//  Created by 황인우 on 8/17/24.
//

import Core
import DomainSharedInterface

import Foundation

public struct Note: Hashable {
    private let uuid: UUID = .init()
    public let id: Int
    public let content: String
    public let status: NoteStatus
    public let createdAt: Date
    private (set) public var lyrics: Lyrics?
    public let publisher: User
    public let song: Song
    public let commentsCount: Int
    public let likesCount: Int
    public let isLiked: Bool
    public let isBookmarked: Bool
    
    public init(
        id: Int,
        content: String,
        status: NoteStatus,
        createdAt: Date,
        lyrics: Lyrics? = nil,
        publisher: User,
        song: Song,
        commentsCount: Int,
        likesCount: Int,
        isLiked: Bool,
        isBookmarked: Bool
    ) {
        self.id = id
        self.content = content
        self.status = status
        self.createdAt = createdAt
        self.lyrics = lyrics
        self.publisher = publisher
        self.song = song
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.isLiked = isLiked
        self.isBookmarked = isBookmarked
    }
    
    public init(dto: NoteResponse) {
        self.id = dto.id
        self.content = dto.content
        self.status = NoteStatus(dto: dto.status)
        self.createdAt = dto.createdAt
        if let dtoLyrics = dto.lyrics {
            self.lyrics = Lyrics(dto: dtoLyrics)
        }
        self.publisher = User(dto: dto.publisher)
        self.song = Song(dto: dto.song)
        self.commentsCount = dto.commentsCount
        self.likesCount = dto.likesCount
        self.isLiked = dto.isLiked
        self.isBookmarked = dto.isBookmarked
    }
}

public enum NoteStatus: Hashable {
    case draft
    case published
    
    public init(dto: NoteStatusDTO) {
        switch dto {
        case .draft:            self = .draft
        case .published:         self = .published
        }
    }
    
    public var toDTO: NoteStatusDTO {
        switch self {
        case .draft:            return .draft
        case .published:        return .published
        }
    }
}
