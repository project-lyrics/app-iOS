//
//  FavoriteArtistHavingNote.swift
//  DomainNoteInterface
//
//  Created by Derrick kim on 10/9/24.
//

import Core
import DomainSharedInterface

public struct FavoriteArtistHavingNote: Hashable {
    public let id: Int
    public let artist: Artist

    public init(
        id: Int,
        artist: Artist
    ) {
        self.id = id
        self.artist = artist
    }

    public init(dto: GetFavoriteArtistHavingNoteResponse) {
        self.id = dto.id
        self.artist = Artist(dto: dto.artist, isFavorite: false)
    }
}

extension FavoriteArtistHavingNote {
    public static let defaultData = FavoriteArtistHavingNote(
        id: Int.max,
        artist: Artist(
            id: Int.max,
            name: "전체보기",
            imageSource: nil,
            isFavorite: false
        )
    )

    public static let mockData: [FavoriteArtistHavingNote] = [
        FavoriteArtistHavingNote(
            id: 122,
            artist: Artist(
                id: 121,
                name: "검",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: false
            )
        ),
        FavoriteArtistHavingNote(
            id: 124,
            artist: Artist(
                id: 123,
                name: "검정",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 126,
            artist: Artist(
                id: 125,
                name: "검정치",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 128,
            artist: Artist(
                id: 127,
                name: "검정치마",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 130,
            artist: Artist(
                id: 129,
                name: "검정치마1",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: false
            )
        ),
        FavoriteArtistHavingNote(
            id: 132,
            artist: Artist(
                id: 131,
                name: "검정치마12",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 132,
            artist: Artist(
                id: 131,
                name: "검정치마123",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 132,
            artist: Artist(
                id: 131,
                name: "검정치마1234",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 132,
            artist: Artist(
                id: 131,
                name: "검정치마12345",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        ),
        FavoriteArtistHavingNote(
            id: 132,
            artist: Artist(
                id: 131,
                name: "검정치마123456",
                imageSource: "https://i.scdn.co/image/ab6761610000e5eb8609536d21beed6769d09d7f",
                isFavorite: true
            )
        )
    ]
}
