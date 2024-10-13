//
//  SearchNoteViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/4/24.
//

import Domain

import Combine
import Foundation

final public class SearchNoteViewModel {
    @Published private (set) var searchedNotes: [SearchedNote] = []
    @Published private (set) var error: NoteError?
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let getSearchedNotesUseCase: GetSearchedNotesUseCaseInterface
    
    public init(getSearchedNotesUseCase: GetSearchedNotesUseCaseInterface) {
        self.getSearchedNotesUseCase = getSearchedNotesUseCase
    }
    
    func searchNotes(
        isInitialFetch: Bool,
        perPage: Int = 10,
        searchText: String = ""
    ) {
        self.getSearchedNotesUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage,
            keyword: searchText
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let searchedNotes):
                if isInitialFetch {
                    self?.searchedNotes = searchedNotes
                } else {
                    self?.searchedNotes.append(contentsOf: searchedNotes)
                }
                
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
}
