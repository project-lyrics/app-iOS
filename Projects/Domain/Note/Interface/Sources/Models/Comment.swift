//
//  Comment.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/10/24.
//

import Foundation

import DomainSharedInterface
import Core

public struct Comment: Hashable {
    private let uuid: UUID = .init()
    
    public let id: Int
    public let content: String
    public let createdAt: Date
    public let writer: User
    
    public init(
        id: Int,
        content: String,
        createdAt: Date,
        writer: User
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.writer = writer
    }
    
    public init(dto: CommentResponse) {
        self.id = dto.id
        self.content = dto.content
        self.createdAt = dto.createdAt
        self.writer = User(dto: dto.writer)
    }
}

extension Comment {
    public static let mockData = [
        Comment(
            id: 1,
            content: "여기가 어디냐면",
            createdAt: Date(),
            writer: User(
                id: 1,
                nickname: "f",
                profileCharacterType: .braidedHair
            )
        ),
        Comment(
            id: 2,
            content: "여기가 어디냐면",
            createdAt: Date(),
            writer: User(
                id: 1,
                nickname: "f",
                profileCharacterType: .braidedHair
            )
        ),
        Comment(
            id: 3,
            content: "여기가 어디냐면",
            createdAt: Date(),
            writer: User(
                id: 1,
                nickname: "f",
                profileCharacterType: .braidedHair
            )
        ),
        Comment(
            id: 4,
            content: "여기가 어디냐면",
            createdAt: Date(),
            writer: User(
                id: 1,
                nickname: "f",
                profileCharacterType: .braidedHair
            )
        )
    ]
}
