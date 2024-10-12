//
//  PatchNoteRequest.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 10/11/24.
//

import Foundation

public struct PatchNoteRequest: Encodable {
    let content: String
    let lyrics: String?
    let background: LyricsBackgroundDTO?
    let status: NoteStatusDTO

    public init(
        content: String,
        lyrics: String?,
        background: LyricsBackgroundDTO?,
        status: NoteStatusDTO
    ) {
        self.content = content
        self.lyrics = lyrics
        self.background = background
        self.status = status
    }
}
