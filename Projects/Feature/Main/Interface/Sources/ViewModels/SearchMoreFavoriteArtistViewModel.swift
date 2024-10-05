//
//  SearchMoreFavoriteArtistViewModel.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 10/5/24.
//

import Domain

import Combine
import Foundation


public final class SearchMoreFavoriteArtistViewModel {
    @Published private (set) var fetchedArtists: [Artist] = []
    @Published private (set) var error: ArtistError?
    
    private let getArtistsUseCase: GetArtistsUseCaseInterface
    private let searchArtistsUseCase: SearchArtistsUseCaseInterface
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(
        getArtistsUseCase: GetArtistsUseCaseInterface,
        searchArtistsUseCase: SearchArtistsUseCaseInterface
    ) {
        self.getArtistsUseCase = getArtistsUseCase
        self.searchArtistsUseCase = searchArtistsUseCase
    }
    
    func fetchArtists(
        isInitialFetch: Bool,
        perPage: Int = 12
    ) {
        self.getArtistsUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let artists):
                if isInitialFetch {
                    self?.fetchedArtists = artists
                } else {
                    self?.fetchedArtists.append(contentsOf: artists)
                }
                
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
    
    func searchArtists(
        isInitial: Bool,
        keyword: String,
        perPage: Int = 12
    ) {
        self.searchArtistsUseCase.execute(
            keyword: keyword,
            perPage: perPage
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let searchedArtists):
                if isInitial {
                    self?.fetchedArtists = searchedArtists
                } else {
                    self?.fetchedArtists.append(contentsOf: searchedArtists)
                }
                
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
    
    func fetchMoreArtists(keyword: String) {
        if keyword.isEmpty {
            self.fetchArtists(isInitialFetch: false)
        } else {
            self.searchArtists(
                isInitial: false,
                keyword: keyword
            )
        }
    }
}
