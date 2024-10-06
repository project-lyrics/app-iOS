//
//  MockGetFavoriteArtistsUseCase.swift
//  FeatureHomeTesting
//
//  Created by 황인우 on 8/18/24.
//

import Combine
import Foundation

import Domain

public struct MockGetFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface {
    public init() {}
    
    public func execute(
        isInitial: Bool,
        perPage: Int
    ) -> AnyPublisher<[Artist], ArtistError> {
        return Just(
            [
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
        )
        .setFailureType(to: ArtistError.self)
        .eraseToAnyPublisher()
    }
}
