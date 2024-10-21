//
//  GetSongDetailUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 10/21/24.
//

import Core
import DomainSharedInterface

import Foundation
import Combine

public protocol GetSongDetailUseCaseInterface {
    func execute(songID: Int) -> AnyPublisher<SongDetail, NoteError>
}

public struct GetSongDetailUseCase: GetSongDetailUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface
    
    public init(noteAPIService: NoteAPIServiceInterface) {
        self.noteAPIService = noteAPIService
    }
    
    public func execute(songID: Int) -> AnyPublisher<SongDetail, NoteError> {
        return noteAPIService.getSongDetail(songID: songID)
            .map(SongDetail.init)
            .eraseToAnyPublisher()
    }
}
