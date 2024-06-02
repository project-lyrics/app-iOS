//
//  NetworkSession.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/31/24.
//

import Combine
import Foundation

public typealias DataTaskResult = (data: Data, response: URLResponse)

open class NetworkSession {
    public let urlSession: URLSession
    public var requestInterceptor: URLRequestInterceptor?
    
    public init(
        urlSession: URLSession = .shared,
        requestInterceptor: URLRequestInterceptor?
    ) {
        self.urlSession = urlSession
        self.requestInterceptor = requestInterceptor
    }
    
    public func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<DataTaskResult, Error> {
        if let interceptor = requestInterceptor {
            return interceptor.adapt(request)
                .flatMap { [unowned self] adaptedRequest -> AnyPublisher<DataTaskResult, Error> in
                    return urlSession.dataTaskPublisher(for: adaptedRequest)
                        .mapError { $0 as Error }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
            
        } else {
            return urlSession.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
    }
}
