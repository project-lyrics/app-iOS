//
//  MockSetBookmarkUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 8/26/24.
//

import Domain

import Combine
import Foundation

public struct MockSetBookmarkUseCase: SetBookmarkUseCaseInterface {
    public init() {}
    
    public func execute(
        isBookmarked: Bool,
        noteID: Int
    ) -> AnyPublisher<Int, NoteError> {
        return Just(noteID)
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
    }
}
