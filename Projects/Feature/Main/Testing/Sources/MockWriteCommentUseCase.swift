//
//  MockWriteCommentUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 9/16/24.
//

import Domain

import Combine
import Foundation

public struct MockWriteCommentUseCase: WriteCommentUseCaseInterface {
    public init() { }
    
    public func execute(
        noteID: Int,
        comment: String
    ) -> AnyPublisher<Bool, NoteError> {
        return Just(true)
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
    }
}
