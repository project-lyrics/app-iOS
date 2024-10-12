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
    
    func getFavoriteArtistHavingNotes() -> AnyPublisher<[GetFavoriteArtistHavingNoteResponse], NoteError>
    func getMyNotes(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int?) -> AnyPublisher<GetMyNotesResponse, NoteError>
    func getMyNotesByBookmark(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int?) -> AnyPublisher<GetMyNotesResponse, NoteError>
    func postLike(noteID: Int) -> AnyPublisher<NoteLikeResponse, NoteError>
    func deleteLike(noteID: Int) -> AnyPublisher<NoteLikeResponse, NoteError>
    
    func postBookmark(noteID: Int) -> AnyPublisher<BookmarkResponse, NoteError>
    func deleteBookmark(noteID: Int) -> AnyPublisher<BookmarkResponse, NoteError>
    
    func deleteNote(noteID: Int) -> AnyPublisher<NoteChangeResponse, NoteError>

    func postNote(
        value: PostNoteValue
    ) -> AnyPublisher<FeelinSuccessResponse, NoteError>
    
    func patchNote(
        noteID: Int,
        value: PatchNoteValue
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
    
    func getArtistNotes(
        currentPage: Int?,
        numberOfNotes: Int,
        hasLyrics: Bool,
        artistID: Int
    ) -> AnyPublisher<GetNotesResponse, NoteError>
}
