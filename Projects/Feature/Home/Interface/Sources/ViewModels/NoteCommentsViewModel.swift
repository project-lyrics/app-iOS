//
//  NoteCommentsViewModel.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/14/24.
//

import Domain

import Combine
import Foundation

public final class NoteCommentsViewModel {
    @Published private (set) var fetchedNotes: [Note] = []
    @Published private (set) var fetchedComments: [Comment] = []
    @Published private (set) var error: NoteError?
    @Published private (set) var refreshState: RefreshState<NoteError> = .idle
    @Published private (set) var commentsCount = 0
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let noteID: Int
    private let setNoteLikeUseCase: SetNoteLikeUseCaseInterface
    private let setBookmarkUseCase: SetBookmarkUseCaseInterface
    private let deleteNoteUseCase: DeleteNoteUseCaseInterface
    private let getNoteWithCommentsUseCase: GetNoteWithCommentsUseCaseInterface
    private let writeCommentUseCase: WriteCommentUseCaseInterface
    private let deleteCommentUseCase: DeleteCommentUseCaseInterface
    
    public init(
        noteID: Int,
        setNoteLikeUseCase: SetNoteLikeUseCaseInterface,
        setBookmarkUseCase: SetBookmarkUseCaseInterface,
        deleteNoteUseCase: DeleteNoteUseCaseInterface,
        getNoteWithCommentsUseCase: GetNoteWithCommentsUseCaseInterface,
        writeCommentUseCase: WriteCommentUseCaseInterface,
        deleteCommentUseCase: DeleteCommentUseCaseInterface
    ) {
        self.noteID = noteID
        self.setNoteLikeUseCase = setNoteLikeUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.getNoteWithCommentsUseCase = getNoteWithCommentsUseCase
        self.writeCommentUseCase = writeCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
    }
    
    func fetchNoteWithComments() {
        self.getNoteWithCommentsUseCase.execute(noteID: self.noteID)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let noteComment):
                    self?.fetchedNotes = [noteComment.note]
                    self?.fetchedComments = noteComment.comments
                    self?.commentsCount = noteComment.commentsCount
                    
                case .failure(let noteError):
                    self?.error = noteError
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshNoteWithComments() {
        self.refreshState = .refreshing
        
        self.getNoteWithCommentsUseCase.execute(noteID: self.noteID)
            .receive(on: DispatchQueue.main)
            .mapToResult()
            .sink { [weak self] result in
                switch result {
                case .success(let noteComment):
                    self?.fetchedNotes = [noteComment.note]
                    self?.fetchedComments = noteComment.comments
                    self?.commentsCount = noteComment.commentsCount
                    
                    self?.refreshState = .completed
                case .failure(let noteError):
                    self?.error = noteError
                    
                    self?.refreshState = .failed(noteError)
                }
            }
            .store(in: &cancellables)
    }
    
    func writeComment(
        comment: String
    ) {
        self.writeCommentUseCase.execute(
            noteID: self.noteID,
            comment: comment
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success:
                self?.fetchNoteWithComments()
                
            case .failure(let error):
                self?.error = error
            }
        }
        .store(in: &cancellables)
    }
}

// MARK: - Bookmark

extension NoteCommentsViewModel {
    func setNoteBookmarkState(
        noteID: Int,
        isBookmarked: Bool
    ) {
        self.setBookmarkUseCase.execute(
            isBookmarked: isBookmarked,
            noteID: noteID
        )
        .receive(on: DispatchQueue.main)
        .mapToResult()
        .sink { [weak self] result in
            switch result {
            case .success(let bookmarkNoteID):
                let indexToUpdate = self?.fetchedNotes.firstIndex(
                    where: { $0.id == bookmarkNoteID }
                )
                
                if let indexToUpdate = indexToUpdate {
                    self?.fetchedNotes[indexToUpdate].isBookmarked = isBookmarked
                }
                
            case .failure(let noteError):
                let indexToUpdate = self?.fetchedNotes.firstIndex(
                    where: { $0.id == noteID }
                )
                
                if let indexToUpdate = indexToUpdate {
                    self?.fetchedNotes[indexToUpdate].isBookmarked = !isBookmarked
                }
                self?.error = noteError
            }
        }
        .store(in: &cancellables)
        
    }
}

// MARK: - Like/Dislike note

extension NoteCommentsViewModel {
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

// MARK: - Edit, Delete, Report Note

extension NoteCommentsViewModel {
    func deleteNote(id: Int) {
        self.deleteNoteUseCase.execute(noteID: id)
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    // TODO: - pop 해야 하나??
                    self?.fetchedNotes.removeAll(where: { $0.id == id })
                    
                case .failure(let noteError):
                    self?.error = noteError
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Delete Comment

extension NoteCommentsViewModel {
    func deleteComment(id: Int) {
        self.deleteCommentUseCase.execute(commentID: id)
            .mapToResult()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.fetchedComments.removeAll(where: { $0.id == id })
                    
                case .failure(let noteError):
                    self?.error = noteError
                }
            }
            .store(in: &cancellables)
    }
}
