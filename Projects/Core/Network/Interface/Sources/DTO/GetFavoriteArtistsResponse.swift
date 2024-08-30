//
//  GetFavoriteArtistsResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 8/23/24.
//

import Foundation

public struct GetFavoriteArtistsResponse: Decodable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let data: [FavoriteArtistReponse]
}

public struct FavoriteArtistReponse: Decodable {
    public let id: Int
    public let artist: ArtistResponse
}
