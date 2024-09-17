//
//  DeleteNoteUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/2/24.
//

import Combine
import Foundation

public protocol DeleteNoteUseCaseInterface {
    func execute(noteID: Int) -> AnyPublisher<Bool, NoteError>
}

public struct DeleteNoteUseCase: DeleteNoteUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface
    
    public init(noteAPIService: NoteAPIServiceInterface) {
        self.noteAPIService = noteAPIService
    }
    
    public func execute(noteID: Int) -> AnyPublisher<Bool, NoteError> {
        return noteAPIService.deleteNote(noteID: noteID)
            .map(\.success)
            .eraseToAnyPublisher()
    }
}
