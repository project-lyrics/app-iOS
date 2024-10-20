//
//  SearchArtistsUseCase.swift
//  DomainArtist
//
//  Created by 황인우 on 7/17/24.
//

import Core
import DomainSharedInterface

import Foundation
import Combine

public protocol SearchArtistsUseCaseInterface {
    func execute(
        keyword: String,
        perPage: Int
    ) -> AnyPublisher<[Artist], ArtistError>
}

public struct SearchArtistsUseCase: SearchArtistsUseCaseInterface {
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
        keyword: String,
        perPage: Int
    ) -> AnyPublisher<[Artist], ArtistError> {
        // 데이터 로딩 중 또는 추가 페이지가 없을 경우 빈 값 리턴
        if artistPaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        // 기존 키워드와 새로운 키워드를 비교하여 값이 다르면 page와 hasNext상태를 초기화 합니다.
        if artistPaginationService.currentSearchWord != keyword {
            artistPaginationService.setCurrentSearchWord(keyword)
            artistPaginationService.update(
                currentPage: 0,
                hasNextPage: true
            )
        }
        
        guard artistPaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        // 데이터 로딩 시작
        artistPaginationService.setLoading(true)
        
        return artistAPIService.searchArtist(
            keyword: keyword,
            currentPage: artistPaginationService.currentPage,
            numberOfArtists: perPage
        )
        .receive(on: DispatchQueue.main)
        .map { [weak artistPaginationService] artistsResponse in
            // 별도로 다음 페이지를 서버에서 주지 않기 때문에 아래와 같이 임의로 페이지 하나를 더 해 준다.
            var nextPage = artistsResponse.hasNext
            ? artistsResponse.pageNumber + 1
            : artistsResponse.pageNumber
            
            // 데이터로딩 완료 & 페이지 상태 업데이트
            artistPaginationService?.setLoading(false)
            artistPaginationService?.update(
                currentPage: nextPage,
                hasNextPage: artistsResponse.hasNext
            )
            
            return artistsResponse.data.map { artistResponse in
                return Artist(
                    dto: artistResponse,
                    isFavorite: false
                )
            }
        }
        .catch({ [weak artistPaginationService] error -> AnyPublisher<[Artist], ArtistError> in
            artistPaginationService?.setLoading(false)
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        })
        .eraseToAnyPublisher()
    }
}
