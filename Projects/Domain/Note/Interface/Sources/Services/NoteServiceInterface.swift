//
//  NoteServiceInterface.swift
//  DomainNote
//
//  Created by Derrick kim on 8/18/24.
//

import Core
import Combine
import Foundation

public protocol NoteServiceInterface {
    func postNote(
        value: PostNoteValue
    ) -> AnyPublisher<NoteResult, NoteError>
    func searchSong(
        keyword: String,
        currentPage: Int,
        numberOfSongs: Int,
        artistID: Int
    ) -> AnyPublisher<SearchSongResponse, NoteError>
}

public struct NoteService {
    public var networkProvider: NetworkProviderInterface

    public init(
        networkProvider: NetworkProviderInterface
    ) {
        self.networkProvider = networkProvider
    }
}
