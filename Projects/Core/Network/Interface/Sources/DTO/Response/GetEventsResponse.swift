//
//  GetEventsResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 3/10/25.
//

import Foundation

public struct GetEventInfoResponse: Decodable {
    public let refusalPeriod: Int
    public let event: GetEventResponse
}

public struct GetEventResponse: Decodable {
    public let nextCursor: Int?
    public let hasNext: Bool
    public let data: [GetEventDetailResponse]
}

public struct GetEventDetailResponse: Decodable {
    public let id: Int
    public let imageUrl: URL
    public let redirectUrl: URL
    public let buttonText: String
}
