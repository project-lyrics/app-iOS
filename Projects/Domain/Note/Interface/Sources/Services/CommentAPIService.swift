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
    func postComment(body: PostCommentRequest) -> AnyPublisher<FeelinSuccessResponse, NoteError>
    func deleteComment(commentID: Int) -> AnyPublisher<FeelinSuccessResponse, NoteError>
}

public struct CommentAPIService: CommentAPIServiceInterface {
    var networkProvider: NetworkProviderInterface
    
    public init(networkProvider: NetworkProviderInterface) {
        self.networkProvider = networkProvider
    }
    
    public func getNoteWithComments(noteID: Int) -> AnyPublisher<NoteCommentsResponse, NoteError> {
        let endpoint = FeelinAPI<NoteCommentsResponse>.getNoteWithComments(noteID: noteID)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func postComment(body: PostCommentRequest) -> AnyPublisher<FeelinSuccessResponse, NoteError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.postComment(body: body)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
    
    public func deleteComment(commentID: Int) -> AnyPublisher<FeelinSuccessResponse, NoteError> {
        let endpoint = FeelinAPI<FeelinSuccessResponse>.deleteComment(commentID: commentID)
        
        return networkProvider.request(endpoint)
            .mapError(NoteError.init)
            .eraseToAnyPublisher()
    }
}
