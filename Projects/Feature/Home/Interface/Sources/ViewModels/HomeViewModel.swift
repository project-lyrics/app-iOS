//
//  HomeViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/17/24.
//

import Domain

import Combine
import Foundation

final public class HomeViewModel {
    typealias NoteFetchResult = Result<[Note], HomeError>
    typealias ArtistFetchResult = Result<[Artist], HomeError>
    
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedFavoriteArtists: [Artist] = []
    @Published private (set) var error: HomeError?
    @Published private (set) var refreshState: RefreshState<HomeError> = .idle
    @Published private (set) var hasUncheckedNotification: Bool = false
    @Published private (set) var isFirstVisitor: Bool = false

    private let getNotesUseCase: GetNotesUseCaseInterface
    private let getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let getHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface
    private let checkFirstVisitorUseCase: CheckFirstVisitorUseCaseInterface

    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(
        getNotesUseCase: GetNotesUseCaseInterface,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        getFavoriteArtistsUseCase: GetFavoriteArtistsUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        getHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface,
        checkFirstVisitorUseCase: CheckFirstVisitorUseCaseInterface
    ) {
        self.getNotesUseCase = getNotesUseCase
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.getFavoriteArtistsUseCase = getFavoriteArtistsUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.getHasUncheckedNotificationUseCase = getHasUncheckedNotificationUseCase
        self.checkFirstVisitorUseCase = checkFirstVisitorUseCase
    }
    
    func fetchArtistsThenNotes(
        notesPerPage: Int = 10,
        artistsPerPage: Int = 30
    ) {
        self.getFavoriteArtistsUseCase.execute(
            isInitial: true,
            perPage: artistsPerPage
        )
        .mapError(HomeError.init)
        .receive(on: DispatchQueue.main)
        .flatMap { [weak self] fetchedFavoriteArtists -> AnyPublisher<[Note], HomeError> in
            self?.fetchedFavoriteArtists = fetchedFavoriteArtists
            
            return self?.getNotesUseCase.execute(
                isInitial: true,
                perPage: notesPerPage,
                mustHaveLyrics: false
            )
            .mapError(HomeError.init)
            .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let fetchedNotes):
                self?.fetchedNotes = fetchedNotes
                
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
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
        .sink { [weak self] result in
            switch result {
            case .success(let artists):
                if isInitialFetch {
                    self?.fetchedFavoriteArtists = artists
                } else {
                    self?.fetchedFavoriteArtists.append(contentsOf: artists)
                }
            case .failure(let error):
                self?.error = .artistError(error)
            }
        }
        .store(in: &cancellables)
    }
    
    func checkForUnReadNotification() {
        self.getHasUncheckedNotificationUseCase.execute()
            .catch({ notificationError in
                return Just(false)
                    .eraseToAnyPublisher()
            })
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$hasUncheckedNotification)
    }

    func checkFirstVisitor() {
        self.checkFirstVisitorUseCase.execute()
            .catch({ isFirst in
                return Just(false)
                    .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .assign(to: &self.$isFirstVisitor)
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
        guard let indexToUpdate = self.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
            return
        }
        
        self.fetchedNotes[indexToUpdate].isLiked = isLiked
        
        let originalLikesCount = self.fetchedNotes[indexToUpdate].likesCount
        
        if isLiked {
            self.fetchedNotes[indexToUpdate].likesCount = originalLikesCount + 1
        } else {
            self.fetchedNotes[indexToUpdate].likesCount = max(0, originalLikesCount - 1)
        }
        
        Just<(isLiked: Bool, noteID: Int)>((isLiked, noteID))
            .setFailureType(to: NoteError.self)
            .map { [unowned self] isLiked, noteID in
                return self.setNoteLikeUseCase.execute(
                    isLiked: isLiked,
                    noteID: noteID
                )
            }
            .switchToLatest()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let updatedNoteLike):
                    self?.fetchedNotes[indexToUpdate].likesCount = updatedNoteLike.likesCount

                case .failure(let error):
                    self?.fetchedNotes[indexToUpdate].isLiked = !isLiked
                    self?.fetchedNotes[indexToUpdate].likesCount = originalLikesCount
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
        guard let indexToUpdate = self.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
            return
        }
        
        self.fetchedNotes[indexToUpdate].isBookmarked = isBookmarked
        
        Just<Bool>(isBookmarked)
            .setFailureType(to: NoteError.self)
            .map { [unowned self] isBookmarked in
                return self.setBookmarkUseCase.execute(
                    isBookmarked: isBookmarked,
                    noteID: noteID
                )
            }
            .switchToLatest()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    return
                    
                case .failure(let error):
                    guard let updatedIndexToUpdate = self?.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
                        return
                    }
                    
                    self?.fetchedNotes[updatedIndexToUpdate].isBookmarked = !isBookmarked
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
