//
//  MockGetNotesUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 8/18/24.
//

import Combine
import Foundation

import Domain

public struct MockGetNotesUseCase: GetNotesUseCaseInterface {
    public init() {}
    
    public func execute(
        isInitial: Bool,
        perPage: Int,
        mustHaveLyrics: Bool
    ) -> AnyPublisher<[Note], NoteError> {
        return Just(
            [
                Note(
                    id: 1,
                    content: "테스트 내용입니다.",
                    status: .published,
                    createdAt: .distantPast,
                    lyrics: .init(
                        content: "난 너의 아픔 속에 너의 고통 속에 기생\n하고 있는 아름다운 벌레야",
                        background: .skyblue
                    ),
                    publisher: .init(
                        id: 1,
                        nickname: "테스트유저1",
                        profileCharacterType: .poopHair
                    ),
                    song: .init(
                        id: 1,
                        name: "everything",
                        imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
                        artist: .init(
                            id: 1,
                            name: "검정치마",
                            imageSource: "www.com",
                            isFavorite: false
                        )
                    ),
                    commentsCount: 0,
                    likesCount: 0,
                    isLiked: false,
                    isBookmarked: false
                ),
                Note(
                    id: 2,
                    content: "테스트 내용입니다2.",
                    status: .published,
                    createdAt: .distantPast,
                    lyrics: .init(
                        content: "난 너의 아픔 속에 너의 고통 속에 기생\n하고 있는 아름다운 벌레야\n 이 밤이 지나고 우린 이상하지 않을까. 우린 어디서부터 잘못된 걸까 알고 싶지만 이제 더 이상 미련도 갖지 않은 내 자신이 이상해",
                        background: .black
                    ),
                    publisher: .init(
                        id: 1,
                        nickname: "테스트유저2",
                        profileCharacterType: .poopHair
                    ),
                    song: .init(
                        id: 1,
                        name: "테스트 노래2",
                        imageUrl: "1234.com",
                        artist: .init(
                            id: 1,
                            name: "테스트 아티스트2",
                            imageSource: "www.com",
                            isFavorite: false
                        )
                    ),
                    commentsCount: 0,
                    likesCount: 0,
                    isLiked: false,
                    isBookmarked: false
                ),
                Note(
                    id: 3,
                    content: "테스트 내용입니다3.",
                    status: .published,
                    createdAt: .distantPast,
                    lyrics: .init(
                        content: "난 너의 아픔 속에 너의 고통",
                        background: .beige
                    ),
                    publisher: .init(
                        id: 1,
                        nickname: "테스트유저3",
                        profileCharacterType: .poopHair
                    ),
                    song: .init(
                        id: 1,
                        name: "테스트 노래3",
                        imageUrl: "1234.com",
                        artist: .init(
                            id: 1,
                            name: "테스트 아티스트3",
                            imageSource: "www.com",
                            isFavorite: false
                        )
                    ),
                    commentsCount: 0,
                    likesCount: 0,
                    isLiked: false,
                    isBookmarked: false
                )
            ]
        )
        .setFailureType(to: NoteError.self)
        .eraseToAnyPublisher()
    }
}
