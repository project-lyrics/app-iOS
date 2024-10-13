//
//  PatchNoteUseCase.swift
//  DomainNoteInterface
//
//  Created by Derrick kim on 10/11/24.
//

import Core
import Foundation
import Combine

public protocol PatchNoteUseCaseInterface {
    func execute(
        noteID: Int,
        value: PatchNoteValue
    ) ->AnyPublisher<FeelinSuccessResponse, NoteError>
}

public struct PatchNoteUseCase: PatchNoteUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface

    public init(
        noteAPIService: NoteAPIServiceInterface
    ) {
        self.noteAPIService = noteAPIService
    }

    public func execute(
        noteID: Int,
        value: PatchNoteValue
    ) -> AnyPublisher<FeelinSuccessResponse, NoteError> {
        return noteAPIService.patchNote(
            noteID: noteID,
            value: value
        )
        .eraseToAnyPublisher()
    }
}
