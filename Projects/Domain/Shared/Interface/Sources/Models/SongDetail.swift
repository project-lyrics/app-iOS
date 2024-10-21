//
//  SongDetail.swift
//  DomainSharedInterface
//
//  Created by 황인우 on 10/21/24.
//

import Core

import Foundation

public struct SongDetail: Hashable {
    private let uuid: UUID = .init()
    public let id: Int
    public let name: String
    public let imageURL: String?
    public let noteCount: Int
    public let artist: Artist
    
    public init(
        id: Int,
        name: String,
        imageURL: String?,
        noteCount: Int,
        artist: Artist
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.noteCount = noteCount
        self.artist = artist
    }
    
    public init(dto: GetSongDetailResponse) {
        self.id = dto.id
        self.name = dto.name
        self.imageURL = dto.imageUrl
        self.noteCount = dto.noteCount
        // SongDetail이 현재 사용되는 화면에서 isFavorite값을 사용하지 않음. 따라서 일단 디폴트로 false처리
        self.artist = Artist(dto: dto.artist, isFavorite: false)
    }
}
