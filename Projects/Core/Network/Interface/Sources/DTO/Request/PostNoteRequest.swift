//
//  PostNoteRequest.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 8/18/24.
//

import Foundation

public struct PostNoteRequest: Encodable {
    let content: String
    let lyrics: String?
    let background: LyricsBackgroundDTO?
    let status: NoteStatusDTO
    let songId: Int
    
    public init(
        content: String,
        lyrics: String?,
        background: LyricsBackgroundDTO?,
        status: NoteStatusDTO,
        songId: Int
    ) {
        self.content = content
        self.lyrics = lyrics
        self.background = background
        self.status = status
        self.songId = songId
    }
}
