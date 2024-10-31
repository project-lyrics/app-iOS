//
//  GetFavoriteArtistsBookmarkedUseCase.swift
//  DomainNoteInterface
//
//  Created by Derrick kim on 10/26/24.
//

import Core

import Foundation
import Combine

public protocol GetFavoriteArtistsBookmarkedUseCaseInterface {
    func execute() -> AnyPublisher<[FavoriteArtistHavingNote], NoteError>
}

public struct GetFavoriteArtistsBookmarkedUseCase: GetFavoriteArtistsBookmarkedUseCaseInterface {

    private let noteAPIService: NoteAPIServiceInterface

    public init(
        noteAPIService: NoteAPIServiceInterface
    ) {
        self.noteAPIService = noteAPIService
    }

    public func execute() -> AnyPublisher<[FavoriteArtistHavingNote], NoteError> {
        return noteAPIService.getFavoriteArtistsBookmarked()
            .receive(on: DispatchQueue.main)
            .map { response in
                var entity = response.map(FavoriteArtistHavingNote.init)
                entity.insert(
                    FavoriteArtistHavingNote.defaultData,
                    at: 0
                )

                return entity
            }
            .eraseToAnyPublisher()
    }
}
