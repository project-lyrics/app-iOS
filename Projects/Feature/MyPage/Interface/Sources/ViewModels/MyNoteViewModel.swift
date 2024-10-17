//
//  MyNoteViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/7/24.
//

import Domain

import Combine
import Foundation

public final class MyNoteViewModel {
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedFavoriteArtistNotes: [FavoriteArtistHavingNote] = []
    @Published private (set) var error: NoteError?
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var selectedArtistID: Int?

    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let getFavoriteArtistsHavingNotesUseCase: GetFavoriteArtistsHavingNotesUseCaseInterface
    private let getMyNotesUseCase: GetMyNotesUseCaseInterface

    public init(
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        getFavoriteArtistsHavingNotesUseCase: GetFavoriteArtistsHavingNotesUseCaseInterface,
        getMyNotesUseCase: GetMyNotesUseCaseInterface
    ) {
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.getFavoriteArtistsHavingNotesUseCase = getFavoriteArtistsHavingNotesUseCase
        self.getMyNotesUseCase = getMyNotesUseCase
    }
}

// MARK: - Like/Dislike note

extension MyNoteViewModel {
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
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Bookmark

extension MyNoteViewModel {
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
                    self?.error = error
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Edit, Delete, Report Note

extension MyNoteViewModel {
    func deleteNote(id: Int) {
        self.deleteNoteUseCase.execute(noteID: id)
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchedNotes.removeAll(where: { $0.id == id })

                case .failure(let noteError):
                    self?.error = noteError
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: FavoriteArtistsNotes, MyNotes

extension MyNoteViewModel {
    func getFavoriteArtists() {
        self.getFavoriteArtistsHavingNotesUseCase.execute()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let data):
                    self?.fetchedFavoriteArtistNotes = data

                case .failure(let noteError):
                    self?.error = noteError
                }
            }
            .store(in: &cancellables)
    }

    func getMyNotes(
        isInitialFetch: Bool,
        perPage: Int = 10,
        artistID: Int? = nil
    ) {
        self.getMyNotesUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage,
            artistID: selectedArtistID
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let data):
                if isInitialFetch {
                    self?.fetchedNotes = data
                    self?.selectedArtistID = artistID
                } else {
                    self?.fetchedNotes.append(contentsOf: data)
                    print(data)
                }
            case .failure(let noteError):
                if let errorCode = noteError.errorCode,
                   // 토큰이 없는 경우 발생하는 에러코드. 일단 해당 뷰모델에서는 무시해야 한다.
                   // 일단 임시로 아래와 같이 처리 추후 수정 필요.
                   errorCode == "01008" {
                    return
                }
                self?.error = noteError
            }
        }
        .store(in: &cancellables)
    }

    func getMoreMyNotesByBookmark() {
        getMyNotes(isInitialFetch: false, artistID: selectedArtistID)
    }
}
