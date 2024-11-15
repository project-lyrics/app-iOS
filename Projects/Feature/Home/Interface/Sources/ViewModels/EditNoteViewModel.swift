//
//  EditNoteViewModel.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 10/11/24.
//

import UIKit
import Combine

import Domain
import Core

public final class EditNoteViewModel {
    typealias EditNoteResult = Result<FeelinSuccessResponse, NoteError>
    
    struct Input {
        let lyricsTextViewTypePublisher: AnyPublisher<String, Never>
        let lyricsBackgroundSelectPublisher: AnyPublisher<LyricsBackground?, Never>
        let noteTextViewTypePublisher: AnyPublisher<String, Never>
        let completeButtonTapPublisher: AnyPublisher<UIControl, Never>
        let editNoteStatusPublisher: AnyPublisher<NoteStatus, Never>
    }

    struct Output {
        let isEnabledCompleteButton: AnyPublisher<Bool, Never>
        let isEnabledLyricsBackgroundButton: AnyPublisher<Bool, Never>
        let isSelectedLyricsBackground: AnyPublisher<LyricsBackground?, Never>
        let editNoteResult: AnyPublisher<EditNoteResult, Never>
    }

    private var cancellables = Set<AnyCancellable>()
    private var error: SongsError?
    private let editNoteUseCase: PatchNoteUseCaseInterface

    public let note: Note

    public init(
        editNoteUseCase: PatchNoteUseCaseInterface,
        note: Note
    ) {
        self.editNoteUseCase = editNoteUseCase
        self.note = note
    }

    func transform(input: Input) -> Output {
        return Output(
            isEnabledCompleteButton: self.isEnabledCompleteButton(input),
            isEnabledLyricsBackgroundButton: self.checkLyricsText(input),
            isSelectedLyricsBackground: self.isSelectLyricsBackground(input),
            editNoteResult: self.editNote(input)
        )
    }
}

private extension EditNoteViewModel {
    func isEnabledCompleteButton(_ input: Input) -> AnyPublisher<Bool, Never> {
        // 노트 내용 변경 확인 (비어있지 않고 이전과 다른 경우)
        
        let isNoteNotEmpty = input.noteTextViewTypePublisher
            .map { $0.isNotEmpty }
            .eraseToAnyPublisher()
        
        let hasValidNoteChanges = input.noteTextViewTypePublisher
            .map { [weak self] noteContent in
                return self?.note.content != noteContent
            }
            .eraseToAnyPublisher()
        
        let hasOptionalChanges = Publishers.CombineLatest(
            input.lyricsTextViewTypePublisher,
            input.lyricsBackgroundSelectPublisher
        )
            .map { [weak self] (updatedLyricsContent, updatedLyricsBackground) in
                
                let originalLyricsText = self?.note.lyrics?.content ?? ""
                
                return originalLyricsText != updatedLyricsContent ||
                self?.note.lyrics?.background != updatedLyricsBackground
            }
            .eraseToAnyPublisher()
        
        return Publishers.CombineLatest3(
            isNoteNotEmpty,
            hasValidNoteChanges,
            hasOptionalChanges
        )
        .map { isNoteNotEmpty, hasNoteChanges, hasOptionalChanges in
            return isNoteNotEmpty && (hasNoteChanges || hasOptionalChanges)
        }
        .eraseToAnyPublisher()
    }

    func isSelectLyricsBackground(_ input: Input) -> AnyPublisher<LyricsBackground?, Never> {
        return input.lyricsBackgroundSelectPublisher
    }

    func checkLyricsText(_ input: Input) -> AnyPublisher<Bool, Never> {
        return input.lyricsTextViewTypePublisher
            .map { text in return text.isNotEmpty }
            .eraseToAnyPublisher()
    }

    func editNote(_ input: Input) -> AnyPublisher<EditNoteResult, Never> {
        let validNotePublisher = Publishers
            .CombineLatest3(
                input.lyricsTextViewTypePublisher,
                input.lyricsBackgroundSelectPublisher,
                input.noteTextViewTypePublisher
            )
            .map { (lyrics, background, noteContent) in
                PatchNoteValue(
                    lyrics: lyrics.isNotEmpty ? lyrics : nil,
                    background: lyrics.isNotEmpty ? background : nil,
                    content: noteContent,
                    status: self.note.status
                )
            }
            .eraseToAnyPublisher()

        return input.completeButtonTapPublisher
            .combineLatest(validNotePublisher)
            .throttle(for: .seconds(2), scheduler: RunLoop.main, latest: false)
            .flatMap { [weak self] (_, value) -> AnyPublisher<EditNoteResult, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.editNote(
                    noteID: self.note.id,
                    with: value
                )
            }
            .eraseToAnyPublisher()
    }

    func editNote(
        noteID: Int,
        with requestValue: PatchNoteValue
    ) -> AnyPublisher<EditNoteResult, Never> {
        return self.editNoteUseCase
            .execute(noteID: noteID, value: requestValue)
            .receive(on: DispatchQueue.main)
            .mapToResult()
    }
}
