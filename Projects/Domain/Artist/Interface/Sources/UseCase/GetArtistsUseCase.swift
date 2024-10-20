//
//  GetArtistsUseCase.swift
//  DomainArtist
//
//  Created by 황인우 on 7/16/24.
//

import Core
import DomainSharedInterface

import Foundation
import Combine
import DomainSharedInterface

public protocol GetArtistsUseCaseInterface {
    func execute(
        isInitial: Bool,
        perPage: Int
    ) -> AnyPublisher<[Artist], ArtistError>
}

public struct GetArtistsUseCase: GetArtistsUseCaseInterface {
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
                currentPage: 0,
                hasNextPage: true
            )
        }
        
        guard artistPaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        artistPaginationService.setLoading(true)
        
        return artistAPIService.getArtists(
            currentPage: artistPaginationService.currentPage,
            numberOfArtists: perPage
        )
        .receive(on: DispatchQueue.main)
        .map { [weak artistPaginationService] artistsResponse in
            // 별도로 다음 페이지를 서버에서 주지 않기 때문에 아래와 같이 임의로 페이지 하나를 더 해 준다.
            let nextPage = artistsResponse.hasNext
            ? artistsResponse.pageNumber + 1
            : artistsResponse.pageNumber
            
            artistPaginationService?.update(
                currentPage: nextPage,
                hasNextPage: artistsResponse.hasNext
            )
            artistPaginationService?.setLoading(false)
            return artistsResponse.data.map { artistResponse in
                return Artist(
                    dto: artistResponse,
                    isFavorite: false
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
