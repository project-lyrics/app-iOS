//
//  UserLoginResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/27/24.
//

import Foundation

public struct UserLoginResponse: Decodable {
    public let status: String
    public let data: TokenResponse
}

public struct TokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
}
