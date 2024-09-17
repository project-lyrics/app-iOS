//
//  PostNoteUseCase.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import Foundation
import Combine

public protocol PostNoteUseCaseInterface {
    func execute(value: PostNoteValue) ->AnyPublisher<FeelinSuccessResponse, NoteError>
}

public struct PostNoteUseCase: PostNoteUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface

    public init(
        noteAPIService: NoteAPIServiceInterface
    ) {
        self.noteAPIService = noteAPIService
    }

    public func execute(value: PostNoteValue) -> AnyPublisher<FeelinSuccessResponse, NoteError> {
        return noteAPIService.postNote(value: value)
            .eraseToAnyPublisher()
    }
}
