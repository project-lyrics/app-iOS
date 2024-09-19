//
//  PostCommentRequest.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 9/14/24.
//

import Foundation

public struct PostCommentRequest: Encodable {
    public let content: String
    public let noteId: Int
    
    public init(
        content: String,
        noteId: Int
    ) {
        self.content = content
        self.noteId = noteId
    }
}
