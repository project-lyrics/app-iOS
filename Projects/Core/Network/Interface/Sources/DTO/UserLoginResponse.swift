//
//  UserLoginResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/27/24.
//

import Foundation

public struct TokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
}
