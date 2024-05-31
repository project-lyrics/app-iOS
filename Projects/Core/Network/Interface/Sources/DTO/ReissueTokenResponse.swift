//
//  ReissueTokenResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/31/24.
//

import Foundation

public struct ReissueTokenResponse: Decodable {
    public let message: String
    public let data: TokenResponse
}
