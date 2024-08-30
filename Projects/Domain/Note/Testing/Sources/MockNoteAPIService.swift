//
//  MockNoteAPIService.swift
//  DomainNote
//
//  Created by 황인우 on 8/18/24.
//

import Combine
import Foundation

import Core
import DomainNoteInterface
import DomainSharedInterface

public struct MockNoteAPIService: NoteAPIServiceInterface {
    private let scenario: DomainTestScenario<NoteError>
    
    public init(scenario: DomainTestScenario<NoteError>) {
        self.scenario = scenario
    }
    
    public func getNotes(currentPage: Int?, numberOfNotes: Int) -> AnyPublisher<GetNotesResponse, NoteError> {
        switch scenario {
        case .success:
            let seedJsonData = DomainSeed.getNoteResponseJsonData
            let expectedModel = try! JSONDecoder().decode(GetNotesResponse.self, from: seedJsonData)
            
            return Just(expectedModel)
                .setFailureType(to: NoteError.self)
                .eraseToAnyPublisher()
            
        case .failure(let noteError):
            return Fail(error: noteError)
                .eraseToAnyPublisher()
        }
    }
}
