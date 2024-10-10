//
//  NoteCommentsResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 9/10/24.
//

import Foundation

public struct NoteCommentsResponse: Decodable {
    public let note: NoteResponse
    public let commentsCount: Int
    public let comments: [CommentResponse]
    
    private enum CodingKeys: String, CodingKey {
        case commentsCount
        case comments
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.note = try NoteResponse(from: decoder)
        self.commentsCount = try container.decode(Int.self, forKey: .commentsCount)
        self.comments = try container.decode(
            [CommentResponse].self,
            forKey: .comments
        )
    }
    
    public init(
        note: NoteResponse,
        commentsCount: Int,
        comments: [CommentResponse]
    ) {
        self.note = note
        self.commentsCount = commentsCount
        self.comments = comments
    }
}
