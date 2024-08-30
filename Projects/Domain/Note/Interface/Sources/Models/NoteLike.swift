//
//  NoteLike.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 8/25/24.
//

import Foundation

import Core

public struct NoteLike: Equatable {
    public let likesCount: Int
    public let noteID: Int
    
    public init(dto: NoteLikeResponse) {
        self.likesCount = dto.likesCount
        self.noteID = dto.noteId
    }
    
    public init(
        likesCount: Int,
        noteID: Int
    ) {
        self.likesCount = likesCount
        self.noteID = noteID
    }
}
