//
//  MockSetNoteLIkeUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 8/25/24.
//

import Domain

import Combine
import Foundation

public struct MockSetNoteLikeUseCase: SetNoteLikeUseCaseInterface {
    public init() {}
    
    public func execute(
        isLiked: Bool,
        noteID: Int
    ) -> AnyPublisher<NoteLike, NoteError> {
        return Just(
            NoteLike(likesCount: 13,
            noteID: 1)
        )
        .setFailureType(to: NoteError.self)
        .eraseToAnyPublisher()
    }
    
    
}
