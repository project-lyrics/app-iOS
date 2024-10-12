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
        let songTapPublisher: AnyPublisher<Song, Never>
        let lyricsTextViewTypePublisher: AnyPublisher<String?, Never>
        let lyricsBackgroundSelectPublisher: AnyPublisher<LyricsBackground?, Never>
        let noteTextViewTypePublisher: AnyPublisher<String, Never>
        let completeButtonTapPublisher: AnyPublisher<UIControl, Never>
        let editNoteStatusPublisher: AnyPublisher<NoteStatus, Never>
    }

    struct Output {
        let isEnabledCompleteButton: AnyPublisher<Bool, Never>
        let isEnabledLyricsBackgroundButton: AnyPublisher<Bool, Never>
        let isSelectedSong: AnyPublisher<Bool, Never>
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
            isSelectedSong: self.isSelectedSong(input), isSelectedLyricsBackground: self.isSelectLyricsBackground(input),
            editNoteResult: self.editNote(input)
        )
    }
}

private extension EditNoteViewModel {
    func isEnabledCompleteButton(_ input: Input) -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(
            input.songTapPublisher,
            input.noteTextViewTypePublisher,
            input.editNoteStatusPublisher
        )
        .map { song, noteContent, status in
            return !noteContent.isEmpty && status == .draft
        }
        .eraseToAnyPublisher()
    }

    func isSelectedSong(_ input: Input) -> AnyPublisher<Bool, Never> {
        return input.songTapPublisher
            .map { song in
                return song.name.isEmpty == false
            }
            .eraseToAnyPublisher()
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
                return text?.isEmpty == false
            }
            .eraseToAnyPublisher()
    }

    func editNote(_ input: Input) -> AnyPublisher<EditNoteResult, Never> {
        let requiredFieldsPublisher = Publishers.CombineLatest3(
            input.songTapPublisher,
            input.noteTextViewTypePublisher,
            input.editNoteStatusPublisher
        )
            .eraseToAnyPublisher()

        let optionalFieldsPublisher = Publishers.CombineLatest(
            input.lyricsTextViewTypePublisher,
            input.lyricsBackgroundSelectPublisher
        )
            .map { (lyrics, background) -> (String?, LyricsBackground?) in
                return (lyrics, background)
            }
            .eraseToAnyPublisher()

        // 필수 필드와 선택 필드를 결합
        let combinedPublisher = requiredFieldsPublisher
            .combineLatest(optionalFieldsPublisher)
            .map { (requiredFields, optionalFields) -> PatchNoteValue in
                let (song, noteContent, status) = requiredFields
                let (lyrics, lyricsBackground) = optionalFields

                return PatchNoteValue(
                    lyrics: lyrics,
                    background: lyricsBackground,
                    content: noteContent,
                    status: status
                )
            }
            .eraseToAnyPublisher()

        return input.completeButtonTapPublisher
            .combineLatest(combinedPublisher)
            .flatMap { [weak self] (_, value) -> AnyPublisher<EditNoteResult, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }

                return self.editNote(
                    noteID: note.id,
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
            .mapError(NoteError.init)
            .mapToResult()
    }
}
