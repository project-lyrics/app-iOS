//
//  NoteLikeResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 8/25/24.
//

import Foundation

public struct NoteLikeResponse: Decodable {
    public let likesCount: Int
    public let noteId: Int
}
