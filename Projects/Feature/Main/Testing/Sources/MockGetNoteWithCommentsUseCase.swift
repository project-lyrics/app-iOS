//
//  MockGetNoteWithCommentsUseCase.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 9/16/24.
//

import Domain

import Combine
import Foundation

public struct MockGetNoteWithCommentsUseCase: GetNoteWithCommentsUseCaseInterface {
    public init() { }
    
    public func execute(noteID: Int) -> AnyPublisher<NoteComments, NoteError> {
        return Just(
            .init(
                note: Note(
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
                commentsCount: 123,
                comments: [
                    .init(
                        id: 1,
                        content: "전 T + Tik Tak Tok도 좋더라고요~",
                        createdAt: .init(),
                        writer: .init(
                            id: 2,
                            nickname: "자경단1호",
                            profileCharacterType: .braidedHair
                        )
                    ),
                    .init(
                        id: 2,
                        content: "자경단1호님 허억 그거 너무너무 좋죠! 후반부 기타솔로가 진짜 예술이라 시간 없으면 그 부분부터 들을 때도 많아요ㅋㅋ",
                        createdAt: .init(),
                        writer: .init(
                            id: 2,
                            nickname: "자경단1호",
                            profileCharacterType: .braidedHair
                        )
                    ),
                    .init(
                        id: 3,
                        content: "그쵸 페스티벌가면 춘추가 매번 그 리프를 다르게 말아줘서 그거 들으러 페스티벌 돌잖아요ㅋㅋ",
                        createdAt: .init(),
                        writer: .init(
                            id: 3,
                            nickname: "실카사랑단",
                            profileCharacterType: .braidedHair
                        )
                    ),
                    .init(
                        id: 4,
                        content: "미쳤다. 미쳤어. 정말 너무 좋아하는 노래에요. 완전 팬입니다.",
                        createdAt: .init(),
                        writer: .init(
                            id: 5,
                            nickname: "실카사랑단23",
                            profileCharacterType: .braidedHair
                        )
                    ),
                    .init(
                        id: 5,
                        content: "미쳤다. 미쳤어. 정말 너무 좋아하는 노래에요. 완전 팬입니다.222222222222222222222222222222222222222222222222222222222222222222222222222222",
                        createdAt: .init(),
                        writer: .init(
                            id: 6,
                            nickname: "실카사랑단24",
                            profileCharacterType: .braidedHair
                        )
                    ),
                    .init(
                        id: 6,
                        content: "미쳤다. 미쳤어. 정말 너무 좋아하는 노래에요. 완전 팬입니다.3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333",
                        createdAt: .init(),
                        writer: .init(
                            id: 3,
                            nickname: "실카사랑단",
                            profileCharacterType: .braidedHair
                        )
                    )
                ]
            )
        )
            .setFailureType(to: NoteError.self)
            .eraseToAnyPublisher()
    }
}
