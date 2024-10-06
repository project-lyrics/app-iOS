//
//  MockDeleteNoteUseCase.swift
//  FeatureHomeTesting
//
//  Created by 황인우 on 9/2/24.
//

import Combine
import Foundation

import Domain

public struct MockDeleteNoteUseCase: DeleteNoteUseCaseInterface {
    public init() {}
    
    public func execute(noteID: Int) -> AnyPublisher<Bool, NoteError> {
        return Just(true)
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
    }
}
