//
//  SearchSongViewModel.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/25/24.
//

import Combine
import UIKit

import Domain

public final class SearchSongViewModel {
    typealias SongFetchResult = Result<[Song], SongsError>

    @Published private (set) var fetchedSongs: [Song] = []
    @Published private (set) var songError: SongsError?

    private let searchSongUseCase: SearchSongUseCaseInterface

    private let artistID: Int
    private var cancellables: Set<AnyCancellable> = .init()

    public init(
        searchSongUseCase: SearchSongUseCaseInterface,
        artistID: Int
    ) {
        self.searchSongUseCase = searchSongUseCase
        self.artistID = artistID
    }

    func fetchMoreSongs(
        keyword: String
    ) {
        self.searchSongs(keyword: keyword, isAppending: true)
    }

    func searchSongs(
        keyword: String = "",
        isAppending: Bool = false
    ) {
        self.executeSearchSong(
            keyword: keyword,
            artistID: artistID
        )
        .sink { [weak self] result in
            switch result {
            case .success(let songs):
                self?.updateSearchedSongs(with: songs, isAppending: isAppending)

            case .failure(let songError):
                self?.songError = songError
            }
        }
        .store(in: &cancellables)
    }
}

private extension SearchSongViewModel {
    func executeSearchSong(
        keyword: String,
        perPage: Int = 20,
        artistID: Int
    ) -> AnyPublisher<SongFetchResult, Never> {
        return self.searchSongUseCase.execute(
            keyword: keyword,
            numberOfSongs: perPage,
            artistID: artistID
        )
        .mapError(SongsError.init)
        .mapToResult()
    }

    func updateSearchedSongs(
        with songs: [Song],
        isAppending: Bool = false
    ) {
        if isAppending {
            self.fetchedSongs.append(contentsOf: songs)
        } else {
            self.fetchedSongs = songs
        }
    }
}
