//
//  PostNoteValue.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import DomainSharedInterface

public struct PostNoteValue {
    let id: Int
    let lyrics: String?
    let background: LyricsBackground?
    let content: String
    let status: NoteStatus

    public init(
        id: Int,
        lyrics: String?,
        background: LyricsBackground?,
        content: String,
        status: NoteStatus
    ) {
        self.id = id
        self.lyrics = lyrics
        self.background = background
        self.content = content
        self.status = status
    }

    public func toDTO() -> PostNoteRequest {
        return PostNoteRequest(
            content: content,
            lyrics: lyrics,
            background: background?.toDTO,
            status: status.toDTO,
            songId: id
        )
    }
}
