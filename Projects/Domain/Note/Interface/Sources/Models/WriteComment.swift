//
//  WriteComment.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/14/24.
//

import Core

import Foundation

public struct WriteComment: Equatable {
    public let content: String
    public let noteID: Int
    
    public init(
        content: String,
        noteID: Int
    ) {
        self.content = content
        self.noteID = noteID
    }
    
    var toDTO: PostCommentRequest {
        return PostCommentRequest(
            content: self.content,
            noteId: self.noteID
        )
    }
}
