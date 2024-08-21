//
//  Artist.swift
//  DomainShared
//
//  Created by 황인우 on 8/17/24.
//

import Foundation

import Core

public struct Artist: Hashable {
    private let uuid: UUID = .init()
    public var id: Int
    public var name: String
    public var imageSource: String?
    public var isFavorite: Bool
    
    public init(
        id: Int,
        name: String,
        imageSource: String?,
        isFavorite: Bool
    ) {
        self.id = id
        self.name = name
        self.imageSource = imageSource
        self.isFavorite = isFavorite
    }
    
    public init(
        dto: ArtistDTO,
        isFavorite: Bool
    ) {
        self.id = dto.id
        self.name = dto.name
        self.imageSource = dto.imageUrl
        self.isFavorite = isFavorite
    }
}
