//
//  PostNoteValue.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import DomainSharedInterface

public struct PostNoteValue {
    public let id: Int
    public let lyrics: String?
    public let background: LyricsBackground?
    public let content: String
    public let status: NoteStatus
    public let noteType: NoteType

    public init(
        id: Int,
        lyrics: String?,
        background: LyricsBackground?,
        content: String,
        status: NoteStatus,
        noteType: NoteType = .free
    ) {
        self.id = id
        self.lyrics = lyrics
        self.background = background
        self.content = content
        self.status = status
        self.noteType = noteType
    }

    public func toDTO() -> PostNoteRequest {
        return PostNoteRequest(
            content: content,
            lyrics: lyrics,
            background: background?.toDTO,
            status: status.toDTO,
            noteType: noteType.toDTO,
            songId: id
        )
    }
}
