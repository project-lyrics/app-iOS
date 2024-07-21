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
    func postFavoriteArtists(ids: [Int]) -> AnyPublisher<EmptyResponse, ArtistError>
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
            cursor: currentPage,
            size: numberOfArtists
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
            query: keyword,
            cursor: currentPage,
            size: numberOfArtists
        )
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
    
    public func postFavoriteArtists(ids: [Int]) -> AnyPublisher<EmptyResponse, ArtistError> {
        let endpoint = FeelinAPI<EmptyResponse>.postFavoriteArtists(ids: ids)
        
        return networkProvider.request(endpoint)
            .mapError(ArtistError.init)
            .eraseToAnyPublisher()
    }
}
