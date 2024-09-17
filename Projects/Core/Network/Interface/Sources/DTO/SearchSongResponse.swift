//
//  SearchSongResponse.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 8/25/24.
//

import Foundation

public struct SearchSongResponse: Decodable {
    public let nextCursor: Int
    public let hasNext: Bool
    public let data: [SongResponse]
}
