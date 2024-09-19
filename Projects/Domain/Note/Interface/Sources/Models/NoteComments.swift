//
//  NoteComments.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/14/24.
//

import Core

import Foundation

public struct NoteComments: Equatable {
    public let note: Note
    public let commentsCount: Int
    public let comments: [Comment]
    
    public init(
        note: Note,
        commentsCount: Int,
        comments: [Comment]
    ) {
        self.note = note
        self.commentsCount = commentsCount
        self.comments = comments
    }
    
    public init(dto: NoteCommentsResponse) {
        self.note = Note(dto: dto.note)
        self.commentsCount = dto.commentsCount
        self.comments = dto.comments.map(Comment.init)
    }
}
