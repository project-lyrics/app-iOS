//
//  SetNoteLikeUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 8/25/24.
//

import Core

import Foundation
import Combine

public protocol SetNoteLikeUseCaseInterface {
    func execute(
        isLiked: Bool,
        noteID: Int
    ) -> AnyPublisher<NoteLike, NoteError>
}

public struct SetNoteLikeUseCase: SetNoteLikeUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface
    
    public init(noteAPIService: NoteAPIServiceInterface) {
        self.noteAPIService = noteAPIService
    }
    
    public func execute(
        isLiked: Bool,
        noteID: Int
    ) -> AnyPublisher<NoteLike, NoteError> {
        print("set notelike usecase isLiked: \(isLiked)")
        
        if isLiked {
            return noteAPIService.postLike(noteID: noteID)
                .map(NoteLike.init)
                .eraseToAnyPublisher()
        } else {
            return noteAPIService.deleteLike(noteID: noteID)
                .map(NoteLike.init)
                .eraseToAnyPublisher()
        }
    }
}
