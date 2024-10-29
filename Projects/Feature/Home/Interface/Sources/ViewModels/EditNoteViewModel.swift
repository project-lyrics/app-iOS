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
        let hasWrittenNotePublisher = input.noteTextViewTypePublisher
            .map { noteContent in
                return self.note.content != noteContent
            }

        let hasWrittenLyricsNotePublisher = input.lyricsTextViewTypePublisher
            .map { lyricsContent in
                return self.note.lyrics?.content != lyricsContent
            }

        let hasSelectedLyricsBackgroundPublisher = input.lyricsBackgroundSelectPublisher
            .map { lyricsBackground in
                return self.note.lyrics?.background != lyricsBackground
            }

        return Publishers
            .Merge3(
                hasWrittenNotePublisher,
                hasWrittenLyricsNotePublisher,
                hasSelectedLyricsBackgroundPublisher
            )
            .map { isEnable in
                return isEnable
            }
            .eraseToAnyPublisher()
    }

    func isEnabledCompleteButton(lyricsContent: String, background: LyricsBackground?, noteContent: String) -> Bool {
        return self.note.lyrics?.content != lyricsContent 
        || self.note.lyrics?.background != background
        || self.note.content != noteContent
    }

    func isSelectLyricsBackground(_ input: Input) -> AnyPublisher<LyricsBackground?, Never> {
        return input.lyricsBackgroundSelectPublisher
            .map { background in
                return background
            }
            .eraseToAnyPublisher()
    }

    func checkLyricsText(_ input: Input) -> AnyPublisher<Bool, Never> {
        return input.lyricsTextViewTypePublisher
            .map { text in
                return text.isEmpty == false && text != "좋아하는 가사를 적어주세요 (선택)"
            }
            .eraseToAnyPublisher()
    }

    func editNote(_ input: Input) -> AnyPublisher<EditNoteResult, Never> {
        let validNotePublisher = Publishers
            .CombineLatest3(
                input.lyricsTextViewTypePublisher,
                input.lyricsBackgroundSelectPublisher,
                input.noteTextViewTypePublisher
            )
            .filter { (lyricsContent, background, noteContent) in
                return self.isEnabledCompleteButton(lyricsContent: lyricsContent, background: background, noteContent: noteContent)
            }
            .map { (lyrics, background, noteContent) in
                PatchNoteValue(
                    lyrics: lyrics != "좋아하는 가사를 적어주세요 (선택)" ? lyrics : nil,
                    background: background,
                    content: noteContent,
                    status: self.note.status
                )
            }
            .eraseToAnyPublisher()

        return input.completeButtonTapPublisher
            .combineLatest(validNotePublisher)
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
