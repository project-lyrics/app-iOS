//
//  GetFavoriteArtistHavingNoteResponse.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 10/9/24.
//

import Foundation

public struct GetFavoriteArtistHavingNoteResponse: Decodable {
    public let id: Int
    public let artist: ArtistResponse
}
