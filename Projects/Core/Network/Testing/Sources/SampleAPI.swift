//
//  SampleAPI.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import CoreNetworkInterface

public enum SampleAPI<R> {
    case search
}

extension SampleAPI: HTTPNetworking {
    public typealias Response = R

    public var baseURL: String? {
        let baseURL = "https://example.com"
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
    
    public var headers: [String : String]? {
        return nil
    }

    public var queryParameters: Encodable? {
        return nil
    }

    public var bodyParameters: Encodable? {
        return nil
    }
}
