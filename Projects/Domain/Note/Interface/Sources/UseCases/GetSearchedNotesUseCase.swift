//
//  GetSearchedNotesUseCase.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/3/24.
//

import Foundation
import Combine

import Core
import DomainSharedInterface

public protocol GetSearchedNotesUseCaseInterface {
    func execute(
        isInitial: Bool,
        perPage: Int,
        keyword: String
    ) -> AnyPublisher<[SearchedNote], NoteError>
}

public struct GetSearchedNotesUseCase: GetSearchedNotesUseCaseInterface {
    private let noteAPIService: NoteAPIServiceInterface
    private let searchedNotePaginationService: KeywordPaginationServiceInterface
    
    public init(
        noteAPIService: NoteAPIServiceInterface,
        searchedNotePaginationService: KeywordPaginationServiceInterface
    ) {
        self.noteAPIService = noteAPIService
        self.searchedNotePaginationService = searchedNotePaginationService
    }
    
    public func execute(
        isInitial: Bool,
        perPage: Int,
        keyword: String
    ) -> AnyPublisher<[SearchedNote], NoteError> {
        if searchedNotePaginationService.isLoading {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        if isInitial {
            self.searchedNotePaginationService.update(
                currentPage: 0,
                hasNextPage: true
            )
        }
        
        // 기존 키워드와 새로운 키워드를 비교하여 값이 다르면 page와 hasNext상태를 초기화 합니다.
        if searchedNotePaginationService.currentSearchWord != keyword {
            searchedNotePaginationService.setCurrentSearchWord(keyword)
            searchedNotePaginationService.update(
                currentPage: 0,
                hasNextPage: true
            )
        }
        
        guard searchedNotePaginationService.hasNextPage else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        return noteAPIService.getSearchedNotes(
            pageNumber: self.searchedNotePaginationService.currentPage ?? 0,
            pageSize: perPage,
            query: keyword
        )
        .receive(on: DispatchQueue.main)
        .map { [weak searchedNotePaginationService] searchedNoteResponse in
            // 별도로 다음 페이지를 서버에서 주지 않기 때문에 아래와 같이 임의로 페이지 하나를 더 해 준다.
            var nextPage = searchedNoteResponse.hasNext
            ? searchedNoteResponse.pageNumber + 1
            : searchedNoteResponse.pageNumber
            
            searchedNotePaginationService?.update(
                currentPage: nextPage,
                hasNextPage: searchedNoteResponse.hasNext
            )
            searchedNotePaginationService?.setLoading(false)
            
            return searchedNoteResponse.data.map(SearchedNote.init)
        }
        .catch { error -> AnyPublisher<[SearchedNote], NoteError> in
            searchedNotePaginationService.setLoading(false)
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
