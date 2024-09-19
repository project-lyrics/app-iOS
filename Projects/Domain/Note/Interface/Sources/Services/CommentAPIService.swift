//
//  CommentAPIService.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/14/24.
//

import Core

import Combine
import Foundation

public protocol CommentAPIServiceInterface {
    func getNoteWithComments(noteID: Int) -> AnyPublisher<NoteCommentsResponse, NoteError>
    func postComment(body: PostCommentRequest) -> AnyPublisher<PostCommentResponse, NoteError>
    func deleteComment(commentId: Int) -> AnyPublisher<DeleteCommentResponse, NoteError>
}

public struct CommentAPIService: CommentAPIServiceInterface {
    var networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func getNoteWithComments(noteID: Int) -> AnyPublisher<NoteCommentsResponse, NoteError> {
        let endpoint = FeelinAPI<NoteCommentsResponse>.getNoteWithComments(noteId: noteID)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func postComment(body: PostCommentRequest) -> AnyPublisher<PostCommentResponse, NoteError> {
        let endpoint = FeelinAPI<PostCommentResponse>.postComment(body: body)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func deleteComment(commentId: Int) -> AnyPublisher<DeleteCommentResponse, NoteError> {
        let endpoint = FeelinAPI<DeleteCommentResponse>.deleteComment(commentId: commentId)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
}
