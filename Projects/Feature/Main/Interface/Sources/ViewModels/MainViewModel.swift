//
//  MainViewModel.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/17/24.
//

import Domain

import Combine
import Foundation

final public class MainViewModel {
    typealias NoteFetchResult = Result<[Note], HomeError>
    typealias ArtistFetchResult = Result<[Artist], HomeError>
    
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedFavoriteArtists: [Artist] = []
    @Published private (set) var error: HomeError?
    
    private let getNotesUseCase: GetNotesUseCaseInterface
    private let getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(
        getNotesUseCase: GetNotesUseCaseInterface,
        getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface
    ) {
        self.getNotesUseCase = getNotesUseCase
        self.getFavoriteArtistsUseCase = getFavoriteArtistsUseCase
    }
    
    func fetchNotes(
        isInitialFetch: Bool,
        perPage: Int = 10
    ) {
        self.getNotesUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage,
            mustHaveLyrics: false
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let notes):
                if isInitialFetch {
                    self?.fetchedNotes = notes
                } else {
                    self?.fetchedNotes.append(contentsOf: notes)
                }
            case .failure(let error):
                self?.error = .noteError(error)
            }
        }
        .store(in: &cancellables)
       
    }
    
    func fetchFavoriteArtists(isInitialFetch: Bool) {
        self.getFavoriteArtistsUseCase.execute(
            isInitial: isInitialFetch,
            perPage: 30
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { result in
            switch result {
            case .success(let artists):
                if isInitialFetch {
                    self.fetchedFavoriteArtists = artists
                } else {
                    self.fetchedFavoriteArtists.append(contentsOf: artists)
                }
            case .failure(let error):
                self.error = .artistError(error)
            }
        }
        .store(in: &cancellables)
    }
}
