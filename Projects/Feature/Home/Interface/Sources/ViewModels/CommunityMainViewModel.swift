//
//  CommunityMainViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/1/24.
//

import Domain

import Combine
import Foundation

public final class CommunityMainViewModel {
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var artist: Artist
    @Published var mustHaveLyrics: Bool = false
    @Published private (set) var error: CommunityError?
    @Published private (set) var refreshState: RefreshState<CommunityError> = .idle
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let getArtistNotesUseCase: GetArtistNotesUseCaseInterface
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let setFavoriteArtistUseCase: SetFavoriteArtistUseCaseInterface
    
    public init(
        artist: Artist,
        getArtistNotesUseCase: GetArtistNotesUseCaseInterface,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        setFavoriteArtistUseCase: SetFavoriteArtistUseCaseInterface
    ) {
        self._artist = .init(initialValue: artist)
        self.getArtistNotesUseCase = getArtistNotesUseCase
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.setFavoriteArtistUseCase = setFavoriteArtistUseCase
        
        // mustHaveLyrics가 변경될 때 데이터를 새로 가져오는 로직
        $mustHaveLyrics
            .sink { [weak self] mustHaveLyrics in
                self?.getArtistNotes(
                    isInitial: true,
                    mustHaveLyrics: mustHaveLyrics
                )
            }
            .store(in: &cancellables)
    }
    
    func getArtistNotes(
        isInitial: Bool,
        mustHaveLyrics: Bool? = nil,
        perPage: Int = 10
    ) {
        self.refreshState = .refreshing
        let artistID = self.artist.id
        
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
}

// MARK: - add/delete favorite Artist

extension CommunityMainViewModel {
    func setFavoriteArtist(_ isFavorite: Bool) {
        Just<Bool>(isFavorite)
            .setFailureType(to: ArtistError.self)
            .map { [unowned self] isFavorite in
                return self.setFavoriteArtistUseCase.execute(
                    artistID: self.artist.id,
                    isFavorite: isFavorite
                )
            }
            .switchToLatest()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.artist.isFavorite = isFavorite
                    
                case .failure(let error):
                    self?.artist.isFavorite = !isFavorite
                    self?.error = .artistError(error)
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

extension CommunityMainViewModel {
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
