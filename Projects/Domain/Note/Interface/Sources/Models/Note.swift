//
//  Note.swift
//  DomainNote
//
//  Created by 황인우 on 8/17/24.
//

import Core
import DomainSharedInterface

import Foundation

public struct Note: Hashable {
    private let uuid: UUID = .init()
    public let id: Int
    public let content: String
    public let status: NoteStatus
    public let createdAt: Date
    public let lyrics: Lyrics?
    public let publisher: User
    public let song: Song
    public var commentsCount: Int
    public var likesCount: Int
    public var isLiked: Bool
    public var isBookmarked: Bool
    
    public init(
        id: Int,
        content: String,
        status: NoteStatus,
        createdAt: Date,
        lyrics: Lyrics? = nil,
        publisher: User,
        song: Song,
        commentsCount: Int,
        likesCount: Int,
        isLiked: Bool,
        isBookmarked: Bool
    ) {
        self.id = id
        self.content = content
        self.status = status
        self.createdAt = createdAt
        self.lyrics = lyrics
        self.publisher = publisher
        self.song = song
        self.commentsCount = commentsCount
        self.likesCount = likesCount
        self.isLiked = isLiked
        self.isBookmarked = isBookmarked
    }
    
    public init(dto: NoteResponse) {
        self.id = dto.id
        self.content = dto.content
        self.status = NoteStatus(dto: dto.status)
        self.createdAt = dto.createdAt
        if let dtoLyrics = dto.lyrics {
            self.lyrics = Lyrics(dto: dtoLyrics)
        } else {
            self.lyrics = nil
        }
        self.publisher = User(dto: dto.publisher)
        self.song = Song(dto: dto.song)
        self.commentsCount = dto.commentsCount
        self.likesCount = dto.likesCount
        self.isLiked = dto.isLiked
        self.isBookmarked = dto.isBookmarked
    }
}

public extension Note {
    static let mockData = [
        Note(
            id: 321,
            content: "테스트 추가 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.테스트 내용입니다.",
            status: .published,
            createdAt: .distantPast,
            lyrics: .init(
                content: "난 너의 아픔 속에 너의 고통 속에 기생\n하고 있는 아름다운 벌레야",
                background: .skyblue
            ),
            publisher: .init(
                id: 321,
                nickname: "테스트유저1",
                profileCharacterType: .poopHair
            ),
            song: .init(
                id: 321,
                name: "everything",
                imageUrl: "https://i.scdn.co/image/ab67616d0000b2739c3a4e471c5e82a457dce2c0",
                artist: .init(
                    id: 321,
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
            id: 322,
            content: "테스트 내용입니다2.",
            status: .published,
            createdAt: .distantPast,
            lyrics: .init(
                content: "난 너의 아픔 속에 너의 고통 속에 기생\n하고 있는 아름다운 벌레야\n 이 밤이 지나고 우린 이상하지 않을까. 우린 어디서부터 잘못된 걸까 알고 싶지만 이제 더 이상 미련도 갖지 않은 내 자신이 이상해",
                background: .black
            ),
            publisher: .init(
                id: 322,
                nickname: "테스트유저2",
                profileCharacterType: .poopHair
            ),
            song: .init(
                id: 322,
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
            id: 323,
            content: "테스트 내용입니다3.",
            status: .published,
            createdAt: .distantPast,
            lyrics: .init(
                content: "난 너의 아픔 속에 너의 고통",
                background: .beige
            ),
            publisher: .init(
                id: 323,
                nickname: "테스트유저3",
                profileCharacterType: .poopHair
            ),
            song: .init(
                id: 323,
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
}
