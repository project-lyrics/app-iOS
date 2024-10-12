//
//  ArtistSelectViewModel.swift
//  FeatureHome
//
//  Created by 황인우 on 7/14/24.
//


import Domain

import Combine
import Foundation

final public class ArtistSelectViewModel {
    typealias ArtistFetchResult = Result<[Artist], ArtistSelectionError>
    typealias InformFavoriteArtistsResult = Result<Void, ArtistSelectionError>
    
    @Published private (set) var fetchedArtists: [Artist] = []
    @Published private (set) var error: ArtistSelectionError?
    @Published private (set) var favoriteArtists: [Artist] = []
    
    private let getArtistsUseCase: GetArtistsUseCaseInterface
    private let searchArtistsUseCase: SearchArtistsUseCaseInterface
    private let postFavoriteArtistsUseCase: PostFavoriteArtistsUseCaseInterface
    
    private let favoriteArtistLimit: Int = 30
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(
        getArtistsUseCase: GetArtistsUseCaseInterface,
        searchArtistsUseCase: SearchArtistsUseCaseInterface,
        postFavoriteArtistsUseCase: PostFavoriteArtistsUseCaseInterface
    ) {
        self.getArtistsUseCase = getArtistsUseCase
        self.searchArtistsUseCase = searchArtistsUseCase
        self.postFavoriteArtistsUseCase = postFavoriteArtistsUseCase
    }
    
    func fetchArtists(
        isInitialFetch: Bool,
        perPage: Int = 10
    ) {
        self.executeGetArtists(
            isInitialFetch: isInitialFetch,
            perPage: perPage
        )
        .sink { [weak self] result in
            switch result {
            case .success(let artists):
                self?.sortFetchedArtists(with: artists)
                
            case .failure(let artistSelectionError):
                self?.error = artistSelectionError
            }
        }
        .store(in: &cancellables)
    }
    
    func searchArtists(
        keyword: String,
        perPage: Int = 12
    ) {
        self.executeSearchAritsts(
            keyword: keyword,
            perPage: perPage
        )
        .sink { [weak self] result in
            switch result {
            case .success(let artists):
                self?.updateSearchedArtists(with: artists)
                
            case .failure(let artistSelectionError):
                self?.error = artistSelectionError
            }
        }
        .store(in: &cancellables)
    }
    
    func fetchMoreArtists(
        keyword: String,
        perPage: Int = 12
    ) {
        if keyword.isEmpty {
            self.executeGetArtists(
                isInitialFetch: false,
                perPage: perPage
            )
            .sink { [weak self] result in
                switch result {
                case .success(let artists):
                    self?.sortFetchedArtists(with: artists, isAppending: true)
                    
                case .failure(let artistSelectionError):
                    self?.error = artistSelectionError
                }
            }
            .store(in: &cancellables)
            
        } else {
            self.executeSearchAritsts(
                keyword: keyword,
                perPage: perPage
            )
            .sink { [weak self] result in
                switch result {
                case .success(let artists):
                    self?.updateSearchedArtists(with: artists, isAppending: true)
                    
                case .failure(let artistSelectionError):
                    self?.error = artistSelectionError
                }
            }
            .store(in: &cancellables)
        }
    }
    
    private func executeSearchAritsts(
        keyword: String,
        perPage: Int
    ) -> AnyPublisher<ArtistFetchResult, Never> {
        return self.searchArtistsUseCase.execute(
            keyword: keyword,
            perPage: perPage
        )
        .map { [favoriteArtists] fetchedArtists -> [Artist] in
            return fetchedArtists.map { fetchedArtist in
                var fetchedArtist = fetchedArtist
                let mustBeFavorite = favoriteArtists.contains {
                    $0.id == fetchedArtist.id
                }
                fetchedArtist.isFavorite = mustBeFavorite
                
                return fetchedArtist
            }
        }
        .mapError(ArtistSelectionError.init)
        .receive(on: DispatchQueue.main)
        .mapToResult()
    }
    
    private func executeGetArtists(
        isInitialFetch: Bool,
        perPage: Int
    ) -> AnyPublisher<ArtistFetchResult, Never> {
        return self.getArtistsUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage
        )
        .map { [favoriteArtists] fetchedArtists -> [Artist] in
            return fetchedArtists.map { fetchedArtist in
                var fetchedArtist = fetchedArtist
                let mustBeFavorite = favoriteArtists.contains {
                    $0.id == fetchedArtist.id
                }
                fetchedArtist.isFavorite = mustBeFavorite
                
                return fetchedArtist
            }
        }
        .mapError(ArtistSelectionError.init)
        .receive(on: DispatchQueue.main)
        .mapToResult()
    }
    
    private func sortFetchedArtists(
        with artists: [Artist],
        isAppending: Bool = false
    ) {
        let nonFavoriteArtists = artists.filter { artist in
            !self.favoriteArtists.contains { $0.id == artist.id }
        }.sorted { $0.id < $1.id }
        
        if isAppending {
            self.fetchedArtists.append(contentsOf: nonFavoriteArtists)
        } else {
            self.fetchedArtists = favoriteArtists + nonFavoriteArtists
        }
    }
    
    private func updateSearchedArtists(
        with artists: [Artist],
        isAppending: Bool = false
    ) {
        if isAppending {
            self.fetchedArtists.append(contentsOf: artists)
        } else {
            self.fetchedArtists = artists
        }
    }
    
    func markFavoriteArtist(
        at index: Int,
        isSearching: Bool
    ) {
        var updatedArtist = self.fetchedArtists[index]
        let wasFavorite = updatedArtist.isFavorite
        updatedArtist.isFavorite.toggle()
        
        let willExceedLimit = favoriteArtists.count >= favoriteArtistLimit && updatedArtist.isFavorite
        
        if willExceedLimit {
            // 이 아티스트를 추가하면 제한을 초과하므로 원래 상태로 되돌립니다
            updatedArtist.isFavorite = wasFavorite
            self.error = .tooManyFavorites(limit: favoriteArtistLimit)
        }
        
        // 가져온 아티스트 목록 업데이트
        self.fetchedArtists[index] = updatedArtist
        
        if updatedArtist.isFavorite {
            // 좋아하는 아티스트라면 즐겨찾기 목록에 추가
            favoriteArtists.append(updatedArtist)
        } else {
            // 아니면 즐겨찾기 목록에서 제거
            favoriteArtists.removeAll { $0.id == updatedArtist.id }
        }
        
        // 전체 검색 화면일 때만 가져온 아티스트 정렬(좋아하는 아티스트를 맨 앞으로 가져오는 정렬)이 필요하기에 예외처리 작업
        if !isSearching {
            self.sortFetchedArtists(with: fetchedArtists)
        }
    }
}

// MARK: - Publisher

extension ArtistSelectViewModel {
    
    func confirmFavoriteArtistsPublisher() -> AnyPublisher<InformFavoriteArtistsResult, Never> {
        let favoriteArtistIds = self.favoriteArtists.map { $0.id }
        return self.postFavoriteArtistsUseCase
            .execute(artistIds: favoriteArtistIds)
            .mapError(ArtistSelectionError.init)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .eraseToAnyPublisher()
    }
}
