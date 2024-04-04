//
//  SampleAPI.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import CoreNetworkInterface

public enum SampleAPI<R> {
    case search(_ requestDTO: AppSearchRequestDTO)
}

extension SampleAPI: HTTPNetworking {
    public typealias Response = R

    public var baseURL: String? {
        let baseURL = "https://itunes.apple.com"
        return baseURL
    }

    public var path: String {
        switch self {
        case .search:
            return "/search"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }

    public var queryParameters: Encodable? {
        switch self {
        case .search(let requestDTO):
            return requestDTO
        }
    }

    public var bodyParameters: Encodable? {
        return nil
    }
}
