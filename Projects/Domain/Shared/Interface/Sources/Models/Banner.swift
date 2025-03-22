//
//  Banner.swift
//  DomainShared
//
//  Created by 황인우 on 3/19/25.
//

import UIKit

import Core
import Shared

public struct Banner: Hashable {
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
    
    public init(dto: GetBannerResponse) {
        self.id = dto.id
        self.imageUrl = dto.imageUrl
        self.redirectUrl = dto.redirectUrl
    }
}
