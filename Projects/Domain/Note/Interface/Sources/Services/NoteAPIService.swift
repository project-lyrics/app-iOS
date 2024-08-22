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
}
