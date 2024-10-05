//
//  SetFavoriteArtistUseCase.swift
//  DomainArtistInterface
//
//  Created by 황인우 on 10/3/24.
//

import Core

import Combine
import Foundation

public protocol SetFavoriteArtistUseCaseInterface {
    func execute(
        artistID: Int,
        isFavorite: Bool
    ) -> AnyPublisher<Bool, ArtistError>
}

public struct SetFavoriteArtistUseCase: SetFavoriteArtistUseCaseInterface {
    private let artistAPIService: ArtistAPIServiceInterface
    
    public init(artistAPIService: ArtistAPIServiceInterface) {
        self.artistAPIService = artistAPIService
    }
    
    public func execute(
        artistID: Int,
        isFavorite: Bool
    ) -> AnyPublisher<Bool, ArtistError> {
        if isFavorite {
            return artistAPIService.postFavoriteArtist(id: artistID)
                .map(\.success)
                .eraseToAnyPublisher()
        } else {
            return artistAPIService.deleteFavoriteArtist(id: artistID)
                .map(\.success)
                .eraseToAnyPublisher()
        }
    }
}
