//
//  PostNoteUseCase.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import Foundation
import Combine

public struct PostNoteUseCase {
    private let noteService: NoteServiceInterface

    public init(
        noteService: NoteServiceInterface
    ) {
        self.noteService = noteService
    }

    public func execute(value: PostNoteValue) -> AnyPublisher<NoteResult, NoteError> {
        return noteService.postNote(value: value)
            .eraseToAnyPublisher()
    }
}
