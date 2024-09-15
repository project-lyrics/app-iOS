//
//  PostNoteViewModel.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/7/24.
//

import UIKit
import Combine

import Domain
import Core

public final class PostNoteViewModel {
    typealias PostNoteResult = Result<FeelinSuccessResponse, NoteError>

    struct Input {
        let songTapPublisher: AnyPublisher<Song, Never>
        let lyricsTextViewTypePublisher: AnyPublisher<String?, Never>
        let lyricsBackgroundSelectPublisher: AnyPublisher<LyricsBackground?, Never>
        let noteTextViewTypePublisher: AnyPublisher<String, Never>
        let completeButtonTapPublisher: AnyPublisher<UIControl, Never>
        let postNoteStatusPublisher: AnyPublisher<NoteStatus, Never>
    }

    struct Output {
        let isEnabledCompleteButton: AnyPublisher<Bool, Never>
        let isEnabledLyricsBackgroundButton: AnyPublisher<Bool, Never>
        let isSelectedSong: AnyPublisher<Bool, Never>
        let isSelectedLyricsBackground: AnyPublisher<LyricsBackground?, Never>
        let postNoteResult: AnyPublisher<PostNoteResult, Never>
    }

    private var cancellables = Set<AnyCancellable>()
    private var error: SongsError?
    private let postNoteUseCase: PostNoteUseCaseInterface

    public let artistID: Int

    public init(
        postNoteUseCase: PostNoteUseCaseInterface,
        artistID: Int
    ) {
        self.postNoteUseCase = postNoteUseCase
        self.artistID = artistID
    }

    func transform(input: Input) -> Output {
        return Output(
            isEnabledCompleteButton: self.isEnabledCompleteButton(input),
            isEnabledLyricsBackgroundButton: self.checkLyricsText(input),
            isSelectedSong: self.isSelectedSong(input), isSelectedLyricsBackground: self.isSelectLyricsBackground(input),
            postNoteResult: self.postNote(input)
        )
    }
}

private extension PostNoteViewModel {
    func isEnabledCompleteButton(_ input: Input) -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(
            input.songTapPublisher,
            input.noteTextViewTypePublisher,
            input.postNoteStatusPublisher
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

    func postNote(_ input: Input) -> AnyPublisher<PostNoteResult, Never> {
        let requiredFieldsPublisher = Publishers.CombineLatest3(
            input.songTapPublisher,
            input.noteTextViewTypePublisher,
            input.postNoteStatusPublisher
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
            .map { (requiredFields, optionalFields) -> PostNoteValue in
                let (song, noteContent, status) = requiredFields
                let (lyrics, lyricsBackground) = optionalFields

                return PostNoteValue(
                    id: song.id,
                    lyrics: lyrics,
                    background: lyricsBackground,
                    content: noteContent,
                    status: status
                )
            }
            .eraseToAnyPublisher()

        // 완료 버튼 탭과 결합된 필드로 노트를 게시
        return input.completeButtonTapPublisher
            .combineLatest(combinedPublisher)
            .flatMap { (_, value) in
                return self.postNote(value)
            }
            .eraseToAnyPublisher()

    }

    func postNote(_ requestValue: PostNoteValue) -> AnyPublisher<PostNoteResult, Never> {
        return self.postNoteUseCase
            .execute(value: requestValue)
            .receive(on: DispatchQueue.main)
            .mapError(NoteError.init)
            .mapToResult()
    }
}
