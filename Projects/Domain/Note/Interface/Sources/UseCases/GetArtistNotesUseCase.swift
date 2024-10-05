//
//  GetArtistNotesUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 10/1/24.
//

import Foundation
import Combine

import Core

public protocol GetArtistNotesUseCaseInterface {
    func execute(
        isInitial: Bool,
        artistID: Int,
        perPage: Int,
        mustHaveLyrics: Bool
    ) -> AnyPublisher<[Note], NoteError>
}

public struct GetArtistNotesUseCase: GetArtistNotesUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface
    private let notePaginationService: NotePaginationServiceInterface
    
    public init(
        noteAPIService: NoteAPIServiceInterface,
        notePaginationService: NotePaginationServiceInterface
    ) {
        self.noteAPIService = noteAPIService
        self.notePaginationService = notePaginationService
    }
    
    public func execute(
        isInitial: Bool,
        artistID: Int,
        perPage: Int,
        mustHaveLyrics: Bool
    ) -> AnyPublisher<[Note], NoteError> {
        if notePaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        if isInitial {
            self.notePaginationService.update(
                currentPage: nil,
                hasNextPage: true
            )
        }
        
        guard notePaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        notePaginationService.setLoading(true)
        
        return noteAPIService.getArtistNotes(
            currentPage: notePaginationService.currentPage,
            numberOfNotes: perPage,
            hasLyrics: mustHaveLyrics,
            artistID: artistID
        )
        .receive(on: DispatchQueue.main)
        .map { [weak notePaginationService] notesResponse in
            notePaginationService?.update(
                currentPage: notesResponse.nextCursor,
                hasNextPage: notesResponse.hasNext
            )
            notePaginationService?.setLoading(false)
            
            return notesResponse.data.map(Note.init)
        }
        .catch { [weak notePaginationService] error -> AnyPublisher<[Note], NoteError> in
            notePaginationService?.setLoading(false)
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
