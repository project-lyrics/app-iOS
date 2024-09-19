//
//  WriteCommentUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/14/24.
//

import Core

import Combine
import Foundation

public protocol WriteCommentUseCaseInterface {
    func execute(
        noteID: Int,
        comment: String
    ) -> AnyPublisher<Bool, NoteError>
}

public struct WriteCommentUseCase: WriteCommentUseCaseInterface {
    private let commentAPIService: CommentAPIServiceInterface
    
    public init(commentAPIService: CommentAPIServiceInterface) {
        self.commentAPIService = commentAPIService
    }
    
    public func execute(
        noteID: Int,
        comment: String
    ) -> AnyPublisher<Bool, NoteError> {
        let writeComment = WriteComment(
            content: comment,
            noteID: noteID
        )
        
        return commentAPIService.postComment(body: writeComment.toDTO)
            .map(\.success)
            .eraseToAnyPublisher()
    }
}
