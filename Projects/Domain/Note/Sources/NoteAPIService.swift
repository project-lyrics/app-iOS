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

    public func getFavoriteArtistHavingNotes() -> AnyPublisher<[GetFavoriteArtistHavingNoteResponse], DomainNoteInterface.NoteError> {
        let endpoint = FeelinAPI<[GetFavoriteArtistHavingNoteResponse]>.getFavoriteArtistsHavingNotes

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func getMyNotes(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int?) -> AnyPublisher<GetMyNotesResponse, NoteError> {
        let endpoint = FeelinAPI<GetMyNotesResponse>.getMyNotes(
            cursor: cursor,
            size: size,
            hasLyrics: hasLyrics,
            artistID: artistID
        )

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }

    public func getMyNotesByBookmark(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int?) -> AnyPublisher<GetMyNotesResponse, NoteError> {
        let endpoint = FeelinAPI<GetMyNotesResponse>.getMyNotesByBookmark(
            cursor: cursor,
            size: size,
            hasLyrics: hasLyrics,
            artistID: artistID
        )

        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
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

    public func patchNote(
        noteID: Int,
        value: PatchNoteValue
    ) -> AnyPublisher<FeelinSuccessResponse, NoteError> {
        let request = value.toDTO()
        let endpoint = FeelinAPI<FeelinSuccessResponse>.patchNote(
            noteID: noteID,
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
    
    public func getSongDetail(songID: Int) -> AnyPublisher<GetSongDetailResponse, NoteError> {
        let endpoint = FeelinAPI<GetSongDetailResponse>.getSongDetail(songID: songID)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func getSongNotes(
        currentPage: Int?,
        numberOfNotes: Int,
        hasLyrics: Bool,
        songID: Int
    ) -> AnyPublisher<GetNotesResponse, NoteError> {
        let endpoint = FeelinAPI<GetNotesResponse>.getSongNotes(
            cursor: currentPage,
            size: numberOfNotes,
            hasLyrics: hasLyrics,
            songID: songID
        )
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func getArtistNotes(
        currentPage: Int?,
        numberOfNotes: Int,
        hasLyrics: Bool,
        artistID: Int
    ) -> AnyPublisher<GetNotesResponse, NoteError> {
        let endpoint = FeelinAPI<GetNotesResponse>.getArtistNotes(
            cursor: currentPage,
            size: numberOfNotes,
            hasLyrics: hasLyrics,
            artistID: artistID
        )
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
}
