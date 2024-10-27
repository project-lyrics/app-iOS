//
//  GetArtistUseCase.swift
//  DomainArtistInterface
//
//  Created by 황인우 on 10/26/24.
//

import Core
import DomainSharedInterface

import Combine
import Foundation

public protocol GetArtistUseCaseInterface {
    func execute(artistID: Int) -> AnyPublisher<Artist, ArtistError>
}

public struct GetArtistUseCase: GetArtistUseCaseInterface {
    private let artistAPIService: ArtistAPIServiceInterface
    
    public init(artistAPIService: ArtistAPIServiceInterface) {
        self.artistAPIService = artistAPIService
    }
    
    public func execute(artistID: Int) -> AnyPublisher<Artist, ArtistError> {
            let artistPublisher = artistAPIService.getArtist(artistID: artistID)
            let isFavoritePublisher = artistAPIService.getIsFavoriteArtist(artistID: artistID)
            
            return artistPublisher
                .zip(isFavoritePublisher)
                .map { artistResponse, isFavoriteResponse in
                    Artist(
                        dto: artistResponse,
                        isFavorite: isFavoriteResponse.exists
                    )
                }
                .eraseToAnyPublisher()
        }
}
