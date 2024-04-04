//
//  NetworkProviderProtocol.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import Combine
import SharedUtilInterface

public protocol NetworkProviderProtocol {
    func request<N: HTTPNetworking, T: Decodable>(_ endpoint: N) -> AnyPublisher<T, NetworkError> where N.Response == T
}
