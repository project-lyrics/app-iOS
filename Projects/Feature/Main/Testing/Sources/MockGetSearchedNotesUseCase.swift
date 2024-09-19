//
//  MockGetSearchedNotesUseCase.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/5/24.
//

import Combine
import Foundation

import DomainNoteInterface

public struct MockGetSearchedNotesUseCase: GetSearchedNotesUseCaseInterface {
    public init() {}
    
    public func execute(
        isInitial: Bool,
        perPage: Int,
        keyword: String
    ) -> AnyPublisher<[SearchedNote], NoteError> {
        return Just([
            SearchedNote(
                id: 1,
                songName: "everything",
                artistName: "검은 치마",
                imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
                noteCount: 1000
            ),
            
            SearchedNote(
                id: 2,
                songName: "ㅈㅅ (Pardon?)",
                artistName: "앤플라잉",
                imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
                noteCount: 1552
            ),
            
            SearchedNote(
                id: 3,
                songName: "고백",
                artistName: "10CM",
                imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
                noteCount: 10
            ),
            
            SearchedNote(
                id: 4,
                songName: "No PAIN",
                artistName: "실리카겔",
                imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
                noteCount: 240
            ),
        ])
        .setFailureType(to: NoteError.self)
        .eraseToAnyPublisher()
    }
    
    
}
