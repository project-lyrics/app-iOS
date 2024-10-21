//
//  GetSongDetailResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 10/21/24.
//

import Foundation

public struct GetSongDetailResponse: Decodable {
    public let id: Int
    public let name: String
    public let imageUrl: String?
    public let noteCount: Int
    public let artist: ArtistResponse
    
    public init(
        id: Int,
        name: String,
        imageUrl: String?,
        noteCount: Int,
        artist: ArtistResponse
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.noteCount = noteCount
        self.artist = artist
    }
}
