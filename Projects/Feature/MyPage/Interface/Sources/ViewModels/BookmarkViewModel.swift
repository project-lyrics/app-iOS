//
//  BookmarkViewModel.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/7/24.
//

import Domain

import Combine
import Foundation

public final class BookmarkViewModel {
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedFavoriteArtistNotes: [FavoriteArtistHavingNote] = []
    @Published private (set) var error: NoteError?

    private var cancellables: Set<AnyCancellable> = .init()
    private var selectedArtistID: Int?

    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let getFavoriteArtistsHavingNotesUseCase: GetFavoriteArtistsHavingNotesUseCaseInterface
    private let getMyNotesByBookmarkUseCase: GetMyNotesByBookmarkUseCaseInterface

    public init(
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        getFavoriteArtistsHavingNotesUseCase: GetFavoriteArtistsHavingNotesUseCaseInterface,
        getMyNotesByBookmarkUseCase: GetMyNotesByBookmarkUseCaseInterface
    ) {
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.getFavoriteArtistsHavingNotesUseCase = getFavoriteArtistsHavingNotesUseCase
        self.getMyNotesByBookmarkUseCase = getMyNotesByBookmarkUseCase
    }
}

// MARK: - Like/Dislike note

extension BookmarkViewModel {
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
                self?.error = error

            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Bookmark

extension BookmarkViewModel {
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

                self?.error = error

            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Edit, Delete, Report Note

extension BookmarkViewModel {
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

// MARK: FavoriteArtistsNotes, MyNotesByBookmark

extension BookmarkViewModel {
    func getFavoriteArtists() {
        self.getFavoriteArtistsHavingNotesUseCase.execute()
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let data):
                    self?.fetchedFavoriteArtistNotes = data

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

    func getMyNotesByBookmark(
        isInitialFetch: Bool,
        perPage: Int = 10,
        artistID: Int? = nil
    ) {
        self.getMyNotesByBookmarkUseCase.execute(
            isInitial: isInitialFetch,
            perPage: perPage,
            artistID: artistID
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
                }
            case .failure(let noteError):
                self?.error = noteError
            }
        }
        .store(in: &cancellables)
    }

    func getMoreMyNotesByBookmark() {
        getMyNotesByBookmark(isInitialFetch: false, artistID: selectedArtistID)
    }
}
