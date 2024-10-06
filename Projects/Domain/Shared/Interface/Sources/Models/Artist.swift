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
    public let id: Int
    public let name: String
    public let imageSource: String?
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
        dto: ArtistResponse,
        isFavorite: Bool
    ) {
        self.id = dto.id
        self.name = dto.name
        self.imageSource = dto.imageUrl
        self.isFavorite = isFavorite
    }
}

public extension Artist {
    static let mockData = [
        Artist(
            id: 1,
            name: "검정치마",
            imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
            isFavorite: true
        ),
        Artist(
            id: 2,
            name: "인디2",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 3,
            name: "인디3",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 4,
            name: "인디4",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 5,
            name: "인디5",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 6,
            name: "인디6",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 7,
            name: "인디7",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 8,
            name: "인디8",
            imageSource: nil,
            isFavorite: true
        ),
        Artist(
            id: 9,
            name: "인디9",
            imageSource: nil,
            isFavorite: true
        )
    ]
}
