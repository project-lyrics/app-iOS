//
//  NoteResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 8/15/24.
//

import Foundation

public struct NoteResponse: Decodable {
    public let id: Int
    public let content: String
    public let status: NoteStatusDTO
    public let createdAt: Date
    public let lyrics: LyricsDTO?
    public let publisher: UserDTO
    public let song: SongResponse
    public let commentsCount: Int
    public let likesCount: Int
    public let isLiked: Bool
    public let isBookmarked: Bool
}

public enum NoteStatusDTO: String, Codable {
    case draft = "DRAFT"
    case published = "PUBLISHED"
}

public struct LyricsDTO: Codable {
    public let lyrics: String
    public let background: LyricsBackgroundDTO
}

public enum LyricsBackgroundDTO: String, Codable {
    case `default` = "DEFAULT"
    case skyblue = "SKYBLUE"
    case blue = "BLUE"
    case lavender = "LAVENDER"
    case mint = "MINT"
    case black = "BLACK"
    case beige = "BEIGE"
    case pinkgreen = "PINKGREEN"
    case red = "RED"
    case white = "WHITE"
    case rainbow = "RAINBOW"
}
