//
//  NoteDetailViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import Domain

import Combine
import Foundation

final public class NoteDetailViewModel {
    
    @Published private (set) var fetchedNotes: [Note] = []
    @Published var mustHaveLyrics: Bool = false
    @Published private (set) var error: NoteError?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    let selectedNote: SearchedNote
    
    private let getSongNotesUseCase: GetSongNotesUseCaseInterface
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    
    public init(
        selectedNote: SearchedNote,
        getSongNotesUseCase: GetSongNotesUseCaseInterface,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface
    ) {
        self.selectedNote = selectedNote
        self.getSongNotesUseCase = getSongNotesUseCase
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        
        
        // mustHaveLyrics가 변경될 때 데이터를 새로 가져오는 로직
        $mustHaveLyrics
            .dropFirst()
            .sink { [weak self] mustHaveLyrics in
                self?.getSongNotes(
                    isInitial: true,
                    mustHaveLyrics: mustHaveLyrics
                )
            }
            .store(in: &cancellables)
    }
    
    func getSongNotes(
        isInitial: Bool,
        mustHaveLyrics: Bool? = nil,
        perPage: Int = 10
    ) {
        let songID = self.selectedNote.songID
        
        self.getSongNotesUseCase.execute(
            isInitial: isInitial,
            perPage: perPage,
            mustHaveLyrics: mustHaveLyrics ?? self.mustHaveLyrics,
            songID: songID
        )
        .mapToResult()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            switch result {
            case .success(let fetchedNotes):
                if isInitial {
                    self?.fetchedNotes = fetchedNotes
                } else {
                    self?.fetchedNotes.append(contentsOf: fetchedNotes)
                }
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
        
    }
}

// MARK: - Like/Dislike note

extension NoteDetailViewModel {
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
            // 좋아요 갯수에는 음수가 없어야 하기에 다음과 같이 max 세팅
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

extension NoteDetailViewModel {
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

extension NoteDetailViewModel {
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
