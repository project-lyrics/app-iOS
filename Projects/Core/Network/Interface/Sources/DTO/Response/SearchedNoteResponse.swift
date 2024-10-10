//
//  SearchedNoteResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 9/3/24.
//

import Foundation

public struct SearchedNotesResponse: Decodable {
    public let pageNumber: Int
    public let hasNext: Bool
    public let data: [SearchedNoteResponse]
    
    public init(
        pageNumber: Int,
        hasNext: Bool,
        data: [SearchedNoteResponse]
    ) {
        self.pageNumber = pageNumber
        self.hasNext = hasNext
        self.data = data
    }
}

public struct SearchedNoteResponse: Decodable {
    public let id: Int
    public let songName: String
    public let artistName: String
    public let imageUrl: String
    public let noteCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case songName = "name"
        case artist
        case imageUrl
        case noteCount
    }
    
    // 아티스트 이름을 매핑하기 위한 Nested keys
    private enum ArtistKeys: String, CodingKey {
        case artistName = "name"
    }
    
    // Nested json을 파싱하기 위한 커스텀 이니셜라이저
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.songName = try container.decode(
            String.self,
            forKey: .songName
        )
        self.imageUrl = try container.decode(
            String.self,
            forKey: .imageUrl
        )
        self.noteCount = try container.decode(
            Int.self,
            forKey: .noteCount
        )
        
        let artistContainer = try container.nestedContainer(
            keyedBy: ArtistKeys.self,
            forKey: .artist
        )
        self.artistName = try artistContainer.decode(
            String.self,
            forKey: .artistName
        )
    }
    
    public init(
        id: Int,
        songName: String,
        artistName: String,
        imageUrl: String,
        noteCount: Int
    ) {
        self.id = id
        self.songName = songName
        self.artistName = artistName
        self.imageUrl = imageUrl
        self.noteCount = noteCount
    }
}
