//
//  GetArtistsResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 7/14/24.
//

import Foundation

public struct GetArtistsResponse: Decodable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let data: [ArtistDTO]
}
