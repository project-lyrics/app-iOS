//
//  NetworkTestDoubles.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 5/28/24.
//
import Combine
import CoreNetworkInterface
import Foundation

// MARK: - MockNetworkProvider
final public class MockNetworkProvider: NetworkProviderInterface {
    private var request: URLRequest?
    private var response: Decodable?
    private var error: NetworkError?
    
    public var endpoint: (any HTTPNetworking)?
    
    public init(
        response: Decodable?,
        error: NetworkError?
    ) {
        self.response = response
        self.error = error
    }
    
    public func request<N, T>(_ endpoint: N) -> AnyPublisher<T, NetworkError> where N : HTTPNetworking, T : Decodable, T == N.Response {
        self.endpoint = endpoint
        
        if let error = error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        guard let response = response as? T else {
            return Fail(
                error: NetworkError.decodingError(
                    "invalid type: \(String(describing: response.self))"
                )
            )
                .eraseToAnyPublisher()
        }
        
        return Just(response)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
