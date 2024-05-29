//
//  TokenInterceptorTestDoubles.swift
//  CoreNetwork
//
//  Created by 황인우 on 5/29/24.
//

import Combine
import CoreNetworkInterface
import Foundation

final public class MockTokenInterceptor: URLRequestInterceptor {
    private let oauthToken: String
    public var request: URLRequest?
    
    public init(oauthToken: String) {
        self.oauthToken = oauthToken
    }
    
    public var adaptMethodCalled: Bool = false
    public var retryMethodCalled: Bool = false
    
    public func adapt(_ urlRequest: URLRequest) -> AnyPublisher<URLRequest, Error> {
        self.adaptMethodCalled = true
        
        self.request = urlRequest
        request?.setValue("Bearer \(oauthToken)", forHTTPHeaderField: "Authorization")
        
        if let request = request {
            return Just(request)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.urlRequestError(.makeURLError))
                .eraseToAnyPublisher()
        }
    }
    
    public func retry(
        with session: URLSession,
        _ request: URLRequest,
        dueTo error: NetworkError
    ) -> AnyPublisher<RetryResult, Never> {
        self.retryMethodCalled = true
        
        return Just(.doNotRetry)
            .eraseToAnyPublisher()
    }
}
