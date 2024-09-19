//
//  CommentResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 9/10/24.
//

import Foundation

public struct CommentResponse: Decodable {
    public let id: Int
    public let content: String
    public let createdAt: Date
    public let writer: UserDTO
    
    public init(
        id: Int,
        content: String,
        createdAt: Date,
        writer: UserDTO
    ) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.writer = writer
    }
}
