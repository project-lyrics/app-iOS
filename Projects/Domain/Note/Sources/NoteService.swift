//
//  NoteService.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import Combine
import DomainNoteInterface

extension NoteService: NoteServiceInterface {
    public func postNote(
        value: PostNoteValue
    ) -> AnyPublisher<NoteResult, NoteError> {
        let request = value.toDTO()
        let endpoint = FeelinAPI<FeelinDefaultResponse>.postNote(
            request: request
        )

        return networkProvider.request(endpoint)
            .map { _ in
                return NoteResult.success
            }
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func searchSong(
        keyword: String,
        currentPage: Int?,
        numberOfSongs: Int
    ) -> AnyPublisher<SearchSongResponse, NoteError> {
        let endpoint = FeelinAPI<SearchSongResponse>.searchSongs(
            query: keyword,
            cursor: currentPage,
            size: numberOfSongs
        )
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
}
