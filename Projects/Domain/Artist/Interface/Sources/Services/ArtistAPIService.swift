//
//  ArtistAPIService.swift
//  DomainArtist
//
//  Created by 황인우 on 7/14/24.
//

import Core

import Combine
import Foundation

public protocol ArtistAPIServiceInterface {
    func getArtists(
        currentPage: Int?,
        numberOfArtists: Int
    ) -> AnyPublisher<GetArtistsResponse, ArtistError>
    func searchArtist(
        keyword: String,
        currentPage: Int?,
        numberOfArtists: Int
    ) -> AnyPublisher<GetArtistsResponse, ArtistError>
    func postFavoriteArtists(ids: [Int]) -> AnyPublisher<FeelinSuccessResponse, ArtistError>
    func getFavoriteArtists(currentPage: Int?, numberOfArtists: Int) -> AnyPublisher<GetFavoriteArtistsResponse, ArtistError>
    func postFavoriteArtist(id: Int) -> AnyPublisher<FeelinSuccessResponse, ArtistError>
    func deleteFavoriteArtist(id: Int) -> AnyPublisher<FeelinSuccessResponse, ArtistError>
}

public struct ArtistAPIService: ArtistAPIServiceInterface {
    var networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func getArtists(
        currentPage: Int?,
        numberOfArtists: Int
    ) -> AnyPublisher<GetArtistsResponse, ArtistError> {
        let endpoint = FeelinAPI<GetArtistsResponse>.getArtists(
            pageNumber: currentPage ?? 0,
            pageSize: numberOfArtists
        )
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
    
    public func searchArtist(
        keyword: String,
        currentPage: Int?,
        numberOfArtists: Int
    ) -> AnyPublisher<GetArtistsResponse, ArtistError> {
        let endpoint = FeelinAPI<GetArtistsResponse>.searchArtists(
            pageNumber: currentPage ?? 0,
            pageSize: numberOfArtists,
            query: keyword
        )
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
    
    public func postFavoriteArtists(ids: [Int]) -> AnyPublisher<FeelinSuccessResponse, ArtistError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.postFavoriteArtists(ids: ids)
        
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
    
    public func getFavoriteArtists(
        currentPage: Int?,
        numberOfArtists: Int
    ) -> AnyPublisher<GetFavoriteArtistsResponse, ArtistError> {
        let endpoint = FeelinAPI<GetFavoriteArtistsResponse>.getFavoriteArtists(
            cursor: currentPage,
            size: numberOfArtists
        )
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
    
    public func postFavoriteArtist(id: Int) -> AnyPublisher<FeelinSuccessResponse, ArtistError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.postFavoriteArtist(id: id)
        
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
        
    }
    
    public func deleteFavoriteArtist(id: Int) -> AnyPublisher<FeelinSuccessResponse, ArtistError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.deleteFavoriteArtist(id: id)
        
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
}
