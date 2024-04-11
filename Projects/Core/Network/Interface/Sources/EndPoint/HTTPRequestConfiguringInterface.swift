//
//  HTTPRequestConfiguringInterface.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation

public protocol HTTPNetworking: HTTPRequestConfiguring, HTTPResponseHandling { }

public protocol HTTPRequestConfiguring {
    var baseURL: String? { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
}
