//
//  PatchNoteValue.swift
//  DomainNoteInterface
//
//  Created by Derrick kim on 10/11/24.
//

import Core
import DomainSharedInterface

public struct PatchNoteValue {
    let lyrics: String?
    let background: LyricsBackground?
    let content: String
    let status: NoteStatus

    public init(
        lyrics: String?,
        background: LyricsBackground?,
        content: String,
        status: NoteStatus
    ) {
        self.lyrics = lyrics
        self.background = background
        self.content = content
        self.status = status
    }

    public func toDTO() -> PatchNoteRequest {
        return PatchNoteRequest(
            content: content,
            lyrics: lyrics,
            background: background?.toDTO,
            status: status.toDTO
        )
    }
}
