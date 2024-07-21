//
//  PostFavoriteArtistsUseCase.swift
//  DomainArtistInterface
//
//  Created by 황인우 on 7/20/24.
//

import Core

import Foundation
import Combine

public struct PostFavoriteArtistsUseCase {
    private let artistAPIService: ArtistAPIServiceInterface
    
    public init(artistAPIService: ArtistAPIServiceInterface) {
        self.artistAPIService = artistAPIService
    }
    
    public func execute(artistIds: [Int]) -> AnyPublisher<Void, ArtistError> {
        return artistAPIService.postFavoriteArtists(ids: artistIds)
            .map {_ in ()}
            .eraseToAnyPublisher()
    }
}
