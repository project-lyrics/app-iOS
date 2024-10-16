//
//  GetFavoriteArtistsUseCase.swift
//  DomainArtistInterface
//
//  Created by 황인우 on 8/15/24.
//

import Core
import DomainSharedInterface

import Foundation
import Combine

public protocol GetFavoriteArtistsUseCaseInterface {
    func execute(
        isInitial: Bool,
        perPage: Int
    ) -> AnyPublisher<[Artist], ArtistError>
}

public struct GetFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface {
    private let artistAPIService: ArtistAPIServiceInterface
    private let artistPaginationService: KeywordPaginationServiceInterface
    
    public init(
        artistAPIService: ArtistAPIServiceInterface,
        artistPaginationService: KeywordPaginationServiceInterface
    ) {
        self.artistAPIService = artistAPIService
        self.artistPaginationService = artistPaginationService
    }
    
    public func execute(
        isInitial: Bool,
        perPage: Int
    ) -> AnyPublisher<[Artist], ArtistError> {
        // 전체검색일 경우 searchWord를 emptyString으로 초기화
        artistPaginationService.setCurrentSearchWord("")
        
        if artistPaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        // 초기 get작업인 경우 페이지 정보를 초기화 합니다.
        if isInitial {
            self.artistPaginationService.update(
                currentPage: nil,
                hasNextPage: true
            )
        }
        
        guard artistPaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        artistPaginationService.setLoading(true)
        
        return artistAPIService.getFavoriteArtists(
            currentPage: artistPaginationService.currentPage,
            numberOfArtists: perPage
        )
        .receive(on: DispatchQueue.main)
        .map { artistsResponse in
            artistPaginationService.update(
                currentPage: artistsResponse.nextCursor,
                hasNextPage: artistsResponse.hasNext
            )
            artistPaginationService.setLoading(false)
            return artistsResponse.data.map { artistResponse in
                return Artist(
                    dto: artistResponse.artist,
                    isFavorite: true
                )
            }
        }
        .catch({ error -> AnyPublisher<[Artist], ArtistError> in
            artistPaginationService.setLoading(false)
            return Fail(error: error)
                .eraseToAnyPublisher()
        })
        .eraseToAnyPublisher()
    }
}
