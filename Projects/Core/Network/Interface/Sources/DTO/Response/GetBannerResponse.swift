//
//  GetBannerResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 3/19/25.
//

import Foundation

public struct GetBannerResponse: Decodable {
    public let id: Int
    public let imageUrl: URL
    public let redirectUrl: URL
    
    public init(
        id: Int,
        imageUrl: URL,
        redirectUrl: URL
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.redirectUrl = redirectUrl
    }
}
