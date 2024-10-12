//
//  GetMyNotesResponse.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 10/9/24.
//

import Foundation

public struct GetMyNotesResponse: Decodable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let data: [NoteResponse]
}
