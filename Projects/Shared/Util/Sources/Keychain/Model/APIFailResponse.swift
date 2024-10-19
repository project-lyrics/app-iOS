//
//  APIFailResponse.swift
//  SharedUtil
//
//  Created by 황인우 on 10/19/24.
//

import Foundation

public struct APIFailResponse: Decodable {
    public let errorCode: String
    public let errorMessage: String
}
