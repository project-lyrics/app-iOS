//
//  MockArtistAPIService.swift
//  DomainArtist
//
//  Created by 황인우 on 8/18/24.
//

import Combine
import Foundation

import Core
import DomainArtistInterface
import DomainSharedInterface

public struct MockArtistAPIService: ArtistAPIServiceInterface {
    private let scenario: DomainTestScenario<ArtistError>
    
    public init(scenario: DomainTestScenario<ArtistError>) {
        self.scenario = scenario
    }
    
    // MARK: - 추후 테스트시 구현 예정
    public func getArtists(currentPage: Int?, numberOfArtists: Int) -> AnyPublisher<GetArtistsResponse, ArtistError> {
        return Empty()
            .setFailureType(to: ArtistError.self)
            .eraseToAnyPublisher()
    }
    
    // TODO: - 추후 테스트 시 구현 예정
    public func searchArtist(keyword: String, currentPage: Int?, numberOfArtists: Int) -> AnyPublisher<GetArtistsResponse, ArtistError> {
        return Empty()
            .setFailureType(to: ArtistError.self)
            .eraseToAnyPublisher()
    }
    
    // TODO: - 추후 테스트 시 구현 예정
    public func postFavoriteArtists(ids: [Int]) -> AnyPublisher<FeelinDefaultResponse, ArtistError> {
        return Empty()
            .setFailureType(to: ArtistError.self)
            .eraseToAnyPublisher()
    }
    
    public func getFavoriteArtists(currentPage: Int?, numberOfArtists: Int) -> AnyPublisher<GetFavoriteArtistsResponse, ArtistError> {
        switch scenario {
        case .success:
            let expectedData = DomainSeed.getNoteResponseJsonData
            
            let expectedModel = try! JSONDecoder().decode(GetFavoriteArtistsResponse.self, from: expectedData)
            
            return Just(expectedModel)
                .setFailureType(to: ArtistError.self)
                .eraseToAnyPublisher()
            
        case .failure(let artistError):
            return Fail(error: artistError)
                .eraseToAnyPublisher()
        }
    }
    
    public func postFavoriteArtist(id: Int) -> AnyPublisher<FeelinSuccessResponse, ArtistError> {
        return Empty()
            .eraseToAnyPublisher()
    }
    
    public func deleteFavoriteArtist(id: Int) -> AnyPublisher<FeelinSuccessResponse, DomainArtistInterface.ArtistError> {
        return Empty()
            .eraseToAnyPublisher()
    }
    
}
