//
//  GetNotesResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 8/15/24.
//

import Foundation

public struct GetNotesResponse: Decodable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let data: [NoteResponse]
}
