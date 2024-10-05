//
//  MockSetFavoriteArtistUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 10/3/24.
//

import Domain

import Combine
import Foundation

public struct MockSetFavoriteArtistUseCase: SetFavoriteArtistUseCaseInterface {
    public init() { }
    
    public func execute(
        artistID: Int,
        isFavorite: Bool
    ) -> AnyPublisher<Bool, ArtistError> {
        return Just(isFavorite)
            .setFailureType(to: ArtistError.self)
            .eraseToAnyPublisher()
    }
}
