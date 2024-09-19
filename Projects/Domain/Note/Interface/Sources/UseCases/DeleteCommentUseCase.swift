//
//  DeleteCommentUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/14/24.
//

import Combine
import Foundation

public protocol DeleteCommentUseCaseInterface {
    func execute(commentID: Int) -> AnyPublisher<Bool, NoteError>
}

public struct DeleteCommentUseCase: DeleteCommentUseCaseInterface {
    private let commentAPIService: CommentAPIServiceInterface
    
    public init(commentAPIService: CommentAPIServiceInterface) {
        self.commentAPIService = commentAPIService
    }
    
    public func execute(commentID: Int) -> AnyPublisher<Bool, NoteError> {
        return commentAPIService.deleteComment(commentID: commentID)
            .map(\.success)
            .eraseToAnyPublisher()
    }
}
