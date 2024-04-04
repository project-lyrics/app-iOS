//
//  FeelinAPI.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import CoreNetworkInterface

extension FeelinAPI: HTTPNetworking {
    public typealias Response = R

    public var baseURL: String? {
        guard let baseURL = Bundle.main.infoDictionary?["Feelin_URL"] as? String else {
            return nil
        }

        return baseURL
    }

    public var path: String {
        return ""
    }

    public var httpMethod: HTTPMethod {
        return .get
    }
}
