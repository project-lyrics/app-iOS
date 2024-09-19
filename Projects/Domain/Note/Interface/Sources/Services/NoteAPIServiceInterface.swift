//
//  NoteAPIServiceInterface.swift
//  DomainNote
//
//  Created by 황인우 on 8/17/24.
//

import Core

import Combine
import Foundation

public protocol NoteAPIServiceInterface {
    func getFavoriteArtistsRelatedNotes(
        currentPage: Int?,
        numberOfNotes: Int,
        hasLyrics: Bool
    ) -> AnyPublisher<GetNotesResponse, NoteError>
    
    func postLike(noteID: Int) -> AnyPublisher<NoteLikeResponse, NoteError>
    func deleteLike(noteID: Int) -> AnyPublisher<NoteLikeResponse, NoteError>
    
    func postBookmark(noteID: Int) -> AnyPublisher<BookmarkResponse, NoteError>
    func deleteBookmark(noteID: Int) -> AnyPublisher<BookmarkResponse, NoteError>
    
    func deleteNote(noteID: Int) -> AnyPublisher<NoteChangeResponse, NoteError>

    func postNote(
        value: PostNoteValue
    ) -> AnyPublisher<FeelinSuccessResponse, NoteError>
    
    func searchSong(
        keyword: String,
        currentPage: Int,
        numberOfSongs: Int,
        artistID: Int
    ) -> AnyPublisher<SearchSongResponse, NoteError>
    
    func getSearchedNotes(
        pageNumber: Int,
        pageSize: Int,
        query: String
    ) -> AnyPublisher<SearchedNotesResponse, NoteError>
    
    func getSongNotes(
        currentPage: Int?,
        numberOfNotes: Int,
        hasLyrics: Bool,
        songID: Int
    ) -> AnyPublisher<GetNotesResponse, NoteError>
}
