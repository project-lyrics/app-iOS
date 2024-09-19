//
//  MockDeleteCommentUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 9/16/24.
//

import Domain

import Combine
import Foundation


public struct MockDeleteCommentUseCase: DeleteCommentUseCaseInterface {
    public init() { }
    
    public func execute(commentID: Int) -> AnyPublisher<Bool, NoteError> {
        return Just(true)
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
    }
}
