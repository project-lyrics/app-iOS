//
//  IsFavoriteArtistResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 10/26/24.
//

import Foundation

public struct IsFavoriteArtistResponse: Decodable {
    public let exists: Bool
    
    public init(exists: Bool) {
        self.exists = exists
    }
}
