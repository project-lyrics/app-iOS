//
//  HomeViewModel.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/17/24.
//

import Domain

import Combine
import Foundation

enum RefreshState {
    case idle        // 대기 상태
    case refreshing  // 새로고침 중
    case completed   // 새로고침 완료
    case failed(HomeError)  // 새로고침 실패 (에러 포함)
}

final public class HomeViewModel {
    typealias NoteFetchResult = Result<[Note], HomeError>
    typealias ArtistFetchResult = Result<[Artist], HomeError>
    
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedFavoriteArtists: [Artist] = []
    @Published private (set) var error: HomeError?
    @Published private (set) var refreshState: RefreshState = .idle
    
    private let getNotesUseCase: GetNotesUseCaseInterface
    private let getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(
        getNotesUseCase: GetNotesUseCaseInterface,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface
    ) {
        self.getNotesUseCase = getNotesUseCase
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.getFavoriteArtistsUseCase = getFavoriteArtistsUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
    }
    
    func fetchNotes(
        isInitialFetch: Bool,
        perPage: Int = 10
    ) {
        self.getNotesUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage,
            mustHaveLyrics: false
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let notes):
                if isInitialFetch {
                    self?.fetchedNotes = notes
                } else {
                    self?.fetchedNotes.append(contentsOf: notes)
                }
            case .failure(let error):
                self?.error = .noteError(error)
            }
        }
        .store(in: &cancellables)
       
    }
    
    func fetchFavoriteArtists(isInitialFetch: Bool) {
        self.getFavoriteArtistsUseCase.execute(
            isInitial: isInitialFetch,
            perPage: 30
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { result in
            switch result {
            case .success(let artists):
                if isInitialFetch {
                    self.fetchedFavoriteArtists = artists
                } else {
                    self.fetchedFavoriteArtists.append(contentsOf: artists)
                }
            case .failure(let error):
                self.error = .artistError(error)
            }
        }
        .store(in: &cancellables)
    }
}

extension HomeViewModel {
    
    // MARK: - Refresh Data
    
    func refreshAllData() {
        let getNotesPublisher = self.getNotesUseCase.execute(
            isInitial: true,
            perPage: 10,
            mustHaveLyrics: false
        )
        .catch { [weak self] noteError in
            self?.refreshState = .failed(.noteError(noteError))
            
            return Just<[Note]>([])
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        let getFavoriteArtistsPublisher = self.getFavoriteArtistsUseCase.execute(
            isInitial: true,
            perPage: 30
        )
        .catch { [weak self] artistError in
            self?.refreshState = .failed(.artistError(artistError))
            
            return Just<[Artist]>([])
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        self.refreshState = .refreshing
        
        Publishers.Zip(
            getNotesPublisher,
            getFavoriteArtistsPublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] (refreshedNotes, refreshedFavoriteArtists) in
            self?.fetchedNotes = refreshedNotes
            self?.fetchedFavoriteArtists = refreshedFavoriteArtists
            
            self?.refreshState = .completed
        }
        .store(in: &cancellables)
        
    }
}

// MARK: - Like/Dislike note

extension HomeViewModel {
    func setNoteLikeState(
        noteID: Int,
        isLiked: Bool
    ) {
        self.setNoteLikeUseCase.execute(
            isLiked: isLiked,
            noteID: noteID
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let updatedNoteLike):
                let indexToUpdate = self?.fetchedNotes.firstIndex(
                    where: { $0.id == noteID }
                )
                
                if let indexToUpdate = indexToUpdate {
                    self?.fetchedNotes[indexToUpdate].isLiked = isLiked
                    self?.fetchedNotes[indexToUpdate].likesCount = updatedNoteLike.likesCount
                }
                
            case .failure(let error):
                let indexToUpdate = self?.fetchedNotes.firstIndex(
                    where: { $0.id == noteID }
                )
                
                if let indexToUpdate = indexToUpdate {
                    self?.fetchedNotes[indexToUpdate].isLiked = !isLiked
                }
                self?.error = .noteError(error)
                
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Bookmark

extension HomeViewModel {
    func setNoteBookmarkState(
        noteID: Int,
        isBookmarked: Bool
    ) {
        self.setBookmarkUseCase.execute(
            isBookmarked: isBookmarked,
            noteID: noteID
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let bookmarkNoteID):
                let indexToUpdate = self?.fetchedNotes.firstIndex(
                    where: { $0.id == bookmarkNoteID }
                )
                
                if let indexToUpdate = indexToUpdate {
                    self?.fetchedNotes[indexToUpdate].isBookmarked = isBookmarked
                }
                
            case .failure(let error):
                let indexToUpdate = self?.fetchedNotes.firstIndex(
                    where: { $0.id == noteID }
                )
                
                if let indexToUpdate = indexToUpdate {
                    self?.fetchedNotes[indexToUpdate].isBookmarked = !isBookmarked
                }
                
                self?.error = .noteError(error)
                
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Edit, Delete, Report Note

extension HomeViewModel {
    func deleteNote(id: Int) {
        self.deleteNoteUseCase.execute(noteID: id)
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchedNotes.removeAll(where: { $0.id == id })
                    
                case .failure(let noteError):
                    self?.error = .noteError(noteError)
                }
            }
            .store(in: &cancellables)
    }
}
