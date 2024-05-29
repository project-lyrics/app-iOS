//
//  URLSession++.swift
//  CoreNetwork
//
//  Created by 황인우 on 5/29/24.
//

import Combine
import CoreNetworkInterface
import Foundation

extension URLSession {
    public func dataTaskPublisher(
        for request: URLRequest,
        interceptor: URLRequestInterceptor?
    ) -> AnyPublisher<DataTaskResult, Error> {
        if let interceptor = interceptor {
            return interceptor.adapt(request)
                .flatMap { [unowned self] adaptedRequest -> AnyPublisher<DataTaskResult, Error> in
                    return self.dataTaskPublisher(for: adaptedRequest)
                        .mapError { $0 as Error }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
            
        } else {
            return self.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
    }
}
