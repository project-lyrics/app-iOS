//
//  MockSetNoteLIkeUseCase.swift
//  FeatureHomeTesting
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
        return if isLiked {
            Just(
                NoteLike(
                    likesCount: 13,
                    noteID: noteID
                )
            )
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
        } else {
            Just(
                NoteLike(
                    likesCount: 0,
                    noteID: noteID
                )
            )
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
        }
    }
}
