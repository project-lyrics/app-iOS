//
//  TokenValidityResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/30/24.
//

import Foundation

public struct UserValidityResponse: Decodable {
    public let message: String
    public let data: TokenValidityResponse
}

public struct TokenValidityResponse: Decodable {
    public let isValid: Bool
    public let expirationDate: Date
}
