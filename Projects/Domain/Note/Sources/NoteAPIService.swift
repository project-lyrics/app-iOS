//
//  NoteAPIService.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import DomainNoteInterface

import Combine
import Foundation


public struct NoteAPIService: NoteAPIServiceInterface {

    private let networkProvider: NetworkProviderInterface

    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }

    public func getFavoriteArtistsRelatedNotes(
        currentPage: Int?,
        numberOfNotes: Int,
        hasLyrics: Bool
    ) -> AnyPublisher<GetNotesResponse, NoteError> {
        let endpoint = FeelinAPI<GetNotesResponse>.getFavoriteArtistsRelatedNotes(
            cursor: currentPage,
            size: numberOfNotes,
            hasLyrics: hasLyrics
        )
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func postLike(noteID: Int) -> AnyPublisher<NoteLikeResponse, NoteError> {
        let endpoint = FeelinAPI<NoteLikeResponse>.postLikes(noteID: noteID)

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func deleteLike(noteID: Int) -> AnyPublisher<NoteLikeResponse, NoteError> {
        let endpoint = FeelinAPI<NoteLikeResponse>.deleteLikes(noteID: noteID)

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func postBookmark(noteID: Int) -> AnyPublisher<BookmarkResponse, NoteError> {
        let endpoint = FeelinAPI<BookmarkResponse>.postBookmarks(noteID: noteID)

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func deleteBookmark(noteID: Int) -> AnyPublisher<BookmarkResponse, NoteError> {
        let endpoint = FeelinAPI<BookmarkResponse>.deleteBookmarks(noteID: noteID)

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func deleteNote(noteID: Int) -> AnyPublisher<NoteChangeResponse, NoteError> {
        let endpoint = FeelinAPI<NoteChangeResponse>.deleteNote(noteID: noteID)

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func postNote(value: PostNoteValue) -> AnyPublisher<FeelinSuccessResponse, NoteError> {
        let request = value.toDTO()
        let endpoint = FeelinAPI<FeelinSuccessResponse>.postNote(
            request: request
        )

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func searchSong(keyword: String, currentPage: Int, numberOfSongs: Int, artistID: Int) -> AnyPublisher<SearchSongResponse, NoteError> {
        let endpoint = FeelinAPI<SearchSongResponse>.searchSongs(
            cursor: currentPage,
            size: numberOfSongs,
            query: keyword,
            artistID: artistID
        )
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func getSearchedNotes(
        pageNumber: Int,
        pageSize: Int,
        query: String
    ) -> AnyPublisher<SearchedNotesResponse, NoteError> {
        let endpoint = FeelinAPI<SearchedNotesResponse>.getSearchedNotes(
            pageNumber: pageNumber,
            pageSize: pageSize,
            query: query
        )
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
}
