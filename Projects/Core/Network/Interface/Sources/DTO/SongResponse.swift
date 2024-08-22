//
//  SongResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 8/18/24.
//

import Foundation

public struct SongResponse: Decodable {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let artist: ArtistResponse
}
