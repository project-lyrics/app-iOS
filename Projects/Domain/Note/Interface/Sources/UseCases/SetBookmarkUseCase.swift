//
//  SetBookmarkUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 8/26/24.
//

import Core

import Foundation
import Combine

public protocol SetBookmarkUseCaseInterface {
    typealias BookmarkNoteID = Int
    
    func execute(isBookmarked: Bool, noteID: Int) -> AnyPublisher<BookmarkNoteID, NoteError>
}

public struct SetBookmarkUseCase: SetBookmarkUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface
    
    public init(noteAPIService: NoteAPIServiceInterface) {
        self.noteAPIService = noteAPIService
    }
    
    public func execute(isBookmarked: Bool, noteID: Int) -> AnyPublisher<BookmarkNoteID, NoteError> {
        
        if isBookmarked {
            return noteAPIService.postBookmark(noteID: noteID)
                .map(\.noteId)
                .eraseToAnyPublisher()
            
        } else {
            return noteAPIService.deleteBookmark(noteID: noteID)
                .map(\.noteId)
                .eraseToAnyPublisher()
        }
    }
}
