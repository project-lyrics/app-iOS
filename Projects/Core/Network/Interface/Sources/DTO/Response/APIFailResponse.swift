//
//  APIFailResponse.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/29/24.
//

import Foundation

public struct APIFailResponse: Decodable {
    public let errorCode: String
    public let errorMessage: String
}
