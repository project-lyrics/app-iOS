//
//  NoteAPIService.swift
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
}

public struct NoteAPIService: NoteAPIServiceInterface {
    var networkProvider: NetworkProviderInterface
    
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
}
