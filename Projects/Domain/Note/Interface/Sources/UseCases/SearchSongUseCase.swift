//
//  SearchSongUseCase.swift
//  DomainNoteInterface
//
//  Created by Derrick kim on 8/25/24.
//

import Foundation
import Combine

import Core
import DomainSharedInterface

public struct SearchSongUseCase {
    private let noteService: NoteServiceInterface
    private let songPaginationService: PaginationServiceInterface

    public init(
        noteService: NoteServiceInterface,
        songPaginationService: PaginationServiceInterface
    ) {
        self.noteService = noteService
        self.songPaginationService = songPaginationService
    }

    public func execute(
        keyword: String,
        numberOfSongs: Int
    ) -> AnyPublisher<[Song], NoteError> {
        if songPaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }

        // 기존 키워드와 새로운 키워드를 비교하여 값이 다르면 page와 hasNext상태를 초기화 합니다.
        if songPaginationService.currentSearchWord != keyword {
            songPaginationService.setCurrentSearchWord(keyword)
            songPaginationService.update(
                currentPage: nil,
                hasNextPage: true
            )
        }

        guard songPaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }

        // 데이터 로딩 시작
        songPaginationService.setLoading(true)

        return noteService.searchSong(
            keyword: keyword,
            currentPage: songPaginationService.currentPage,
            numberOfSongs: numberOfSongs
        )
        .receive(on: DispatchQueue.main)
        .map { [weak songPaginationService] songsResponse in

            // 데이터로딩 완료 & 페이지 상태 업데이트
            songPaginationService?.setLoading(false)
            songPaginationService?.update(
                currentPage: songsResponse.nextCursor,
                hasNextPage: songsResponse.hasNext
            )

            return songsResponse.data.map { songResponse in
                return Song(dto: songResponse)
            }
        }
        .catch { [weak songPaginationService] error -> AnyPublisher<[Song], NoteError> in
            songPaginationService?.setLoading(false)

            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
