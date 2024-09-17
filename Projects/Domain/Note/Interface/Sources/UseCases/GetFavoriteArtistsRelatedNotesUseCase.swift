//
//  GetFavoriteArtistsRelatedNotesUseCase.swift
//  DomainNote
//
//  Created by 황인우 on 8/17/24.
//

import Core

import Foundation
import Combine

public protocol GetNotesUseCaseInterface {
    func execute(
        isInitial: Bool,
        perPage: Int,
        mustHaveLyrics: Bool
    ) -> AnyPublisher<[Note], NoteError>
}

public struct GetFavoriteArtistsRelatedNotesUseCase: GetNotesUseCaseInterface {
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
        perPage: Int,
        mustHaveLyrics: Bool
    ) -> AnyPublisher<[Note], NoteError> {
        
        if notePaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        // 초기 get작업인 경우 페이지 정보를 초기화 합니다.
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
        
        return noteAPIService.getFavoriteArtistsRelatedNotes(
            currentPage: notePaginationService.currentPage,
            numberOfNotes: perPage,
            hasLyrics: mustHaveLyrics
        )
        .receive(on: DispatchQueue.main)
        .map { notesResponse in
            notePaginationService.update(
                currentPage: notesResponse.nextCursor,
                hasNextPage: notesResponse.hasNext
            )
            notePaginationService.setLoading(false)
            return notesResponse.data.map { noteResponse in
                return Note(dto: noteResponse)
            }
        }
        .catch({ error -> AnyPublisher<[Note], NoteError> in
            notePaginationService.setLoading(false)
            return Fail(error: error)
                .eraseToAnyPublisher()
        })
        .eraseToAnyPublisher()
    }
}
