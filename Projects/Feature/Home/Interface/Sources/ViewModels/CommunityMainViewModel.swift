//
//  CommunityMainViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/1/24.
//

import Domain

import Combine
import Foundation

enum FavoriteArtistAlertState {
    case initial
    case isFavorite
    case isRemoved
}

public final class CommunityMainViewModel {
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedArtist: Artist?
    @Published var mustHaveLyrics: Bool = false
    @Published private (set) var hasUncheckedNotification: Bool = false

    @Published private (set) var error: CommunityError?
    @Published private (set) var refreshState: RefreshState<CommunityError> = .idle
    @Published private (set) var logoutResult: LogoutResult = .none
    @Published private (set) var favoriteArtistAlertState: FavoriteArtistAlertState = .initial
    @Published private (set) var deleteNoteResult: DeleteNoteResult = .none

    private var cancellables: Set<AnyCancellable> = .init()
    
    private (set) var artistID: Int
    private let getArtistUseCase: GetArtistUseCaseInterface
    private let getArtistNotesUseCase: GetArtistNotesUseCaseInterface
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let setFavoriteArtistUseCase: SetFavoriteArtistUseCaseInterface
    private let getHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface
    private let logoutUseCase: LogoutUseCaseInterface

    public init(
        artistID: Int,
        getArtistUseCase: GetArtistUseCase,
        getArtistNotesUseCase: GetArtistNotesUseCaseInterface,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        setFavoriteArtistUseCase: SetFavoriteArtistUseCaseInterface,
        getHasUncheckedNotificationUseCase: GetHasUncheckedNotificationUseCaseInterface,
        logoutUseCase: LogoutUseCaseInterface
    ) {
        self.artistID = artistID
        self.getArtistUseCase = getArtistUseCase
        self.getArtistNotesUseCase = getArtistNotesUseCase
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.setFavoriteArtistUseCase = setFavoriteArtistUseCase
        self.getHasUncheckedNotificationUseCase = getHasUncheckedNotificationUseCase
        self.logoutUseCase = logoutUseCase
        
        $mustHaveLyrics
            .dropFirst()
            .sink { [weak self] mustHaveLyrics in
                self?.getArtistNotes(
                    isInitial: true,
                    mustHaveLyrics: mustHaveLyrics
                )
            }
            .store(in: &cancellables)
        
    }
    
    func getArtistAndNotes() {
        self.refreshState = .refreshing
        
        let getArtist = self.getArtistUseCase.execute(artistID: self.artistID)
            .mapError(CommunityError.init)
            .eraseToAnyPublisher()
        
        let getNotes = self.getArtistNotesUseCase.execute(
            isInitial: true,
            artistID: self.artistID,
            perPage: 10,
            mustHaveLyrics: self.mustHaveLyrics
        )
        .mapError(CommunityError.init)
        .eraseToAnyPublisher()
        
        Publishers.Zip(getArtist, getNotes)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let (fetchedArtist, fetchedNotes)):
                    self?.fetchedArtist = fetchedArtist
                    self?.fetchedNotes = fetchedNotes
                    self?.refreshState = .completed
                    
                case .failure(let error):
                    self?.error = error
                    self?.refreshState = .failed(error)
                }
            })
            .store(in: &cancellables)
    }
    
    func getArtistNotes(
        isInitial: Bool,
        mustHaveLyrics: Bool? = nil,
        perPage: Int = 10
    ) {
        self.refreshState = .refreshing
        
        self.getArtistNotesUseCase.execute(
            isInitial: isInitial,
            artistID: artistID,
            perPage: perPage,
            mustHaveLyrics: mustHaveLyrics ?? self.mustHaveLyrics
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let fetchedNotes):
                if isInitial {
                    self?.fetchedNotes = fetchedNotes
                } else {
                    self?.fetchedNotes.append(contentsOf: fetchedNotes)
                }
                self?.refreshState = .completed
                
            case .failure(let error):
                self?.refreshState = .failed(.noteError(error))
                self?.error = .noteError(error)
            }
        }
        .store(in: &cancellables)
    }
    
    func logout() {
        self.logoutUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.logoutResult = .success
                    
                case .failure(let error):
                    self?.logoutResult = .failure(error)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - add/delete favorite Artist

extension CommunityMainViewModel {
    func setFavoriteArtist(_ isFavorite: Bool) {
        Just<Bool>(isFavorite)
            .setFailureType(to: CommunityError.self)
            .map { [unowned self] isFavorite in
                return self.setFavoriteArtistUseCase.execute(
                    artistID: self.artistID,
                    isFavorite: isFavorite
                )
                .mapError(CommunityError.init)
            }
            .switchToLatest()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchedArtist?.isFavorite = isFavorite
                    
                    if isFavorite {
                        self?.favoriteArtistAlertState = .isFavorite
                    } else {
                        self?.favoriteArtistAlertState = .isRemoved
                    }
                    
                case .failure(let error):
                    self?.fetchedArtist?.isFavorite = !isFavorite
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Like/Dislike note

extension CommunityMainViewModel {
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
            .setFailureType(to: CommunityError.self)
            .map { [unowned self] isLiked, noteID in
                return self.setNoteLikeUseCase.execute(
                    isLiked: isLiked,
                    noteID: noteID
                )
                .mapError(CommunityError.init)
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
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Bookmark

extension CommunityMainViewModel {
    func setNoteBookmarkState(
        noteID: Int,
        isBookmarked: Bool
    ) {
        guard let indexToUpdate = self.fetchedNotes.firstIndex(where: { $0.id == noteID }) else {
            return
        }
        
        self.fetchedNotes[indexToUpdate].isBookmarked = isBookmarked
        
        Just<Bool>(isBookmarked)
            .setFailureType(to: CommunityError.self)
            .map { [unowned self] isBookmarked in
                return self.setBookmarkUseCase.execute(
                    isBookmarked: isBookmarked,
                    noteID: noteID
                )
                .mapError(CommunityError.init)
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
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Edit, Delete, Report Note

extension CommunityMainViewModel {
    func deleteNote(id: Int) {
        self.deleteNoteUseCase.execute(noteID: id)
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchedNotes.removeAll(where: { $0.id == id })
                    self?.deleteNoteResult = .success

                case .failure(let error):
                    self?.deleteNoteResult = .failure(error)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Unchecked Notification

extension CommunityMainViewModel {
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
}
