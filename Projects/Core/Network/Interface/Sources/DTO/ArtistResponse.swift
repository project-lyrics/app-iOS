//
//  ArtistResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 7/14/24.
//

import Foundation

public struct ArtistResponse: Decodable {
    public let id: Int
    public let name: String
    public let imageUrl: String?
}
