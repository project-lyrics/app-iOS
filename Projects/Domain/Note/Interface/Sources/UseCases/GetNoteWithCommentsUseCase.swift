//
//  GetNoteWithCommentsUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/10/24.
//

import Combine
import Foundation

public protocol GetNoteWithCommentsUseCaseInterface {
    func execute(noteID: Int) -> AnyPublisher<NoteComments, NoteError>
}

public struct GetNoteWithCommentsUseCase: GetNoteWithCommentsUseCaseInterface {
    private let commentAPIService: CommentAPIServiceInterface
    
    public init(commentAPIService: CommentAPIServiceInterface) {
        self.commentAPIService = commentAPIService
    }
    
    public func execute(noteID: Int) -> AnyPublisher<NoteComments, NoteError> {
        return commentAPIService.getNoteWithComments(noteID: noteID)
            .map(NoteComments.init)
            .eraseToAnyPublisher()
    }
}
