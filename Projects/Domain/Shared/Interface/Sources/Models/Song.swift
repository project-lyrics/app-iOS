//
//  Song.swift
//  DomainSharedInterface
//
//  Created by 황인우 on 8/18/24.
//

import Core

import Foundation

public struct Song: Hashable {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let artist: Artist
    
    public init(
        id: Int,
        name: String,
        imageUrl: String,
        artist: Artist
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.artist = artist
    }
    
    public init(dto: SongResponse) {
        self.id = dto.id
        self.name = dto.name
        self.imageUrl = dto.imageUrl
        self.artist = Artist(
            dto: dto.artist,
            isFavorite: false
        )
    }
}
