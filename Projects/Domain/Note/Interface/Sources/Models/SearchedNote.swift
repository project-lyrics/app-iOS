//
//  SearchedNote.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/3/24.
//

import Foundation

import Core

public struct SearchedNote: Hashable {
    private let uuid: UUID = .init()
    public let songID: Int
    public let songName: String
    public let artistName: String
    public let albumImageUrl: String
    public let noteCount: Int
    
    public init(
        id: Int,
        songName: String,
        artistName: String,
        imageUrl: String,
        noteCount: Int
    ) {
        self.songID = id
        self.songName = songName
        self.artistName = artistName
        self.albumImageUrl = imageUrl
        self.noteCount = noteCount
    }
    
    public init(dto: SearchedNoteResponse) {
        self.songID = dto.id
        self.songName = dto.songName
        self.artistName = dto.artistName
        self.albumImageUrl = dto.imageUrl
        self.noteCount = dto.noteCount
    }
}
