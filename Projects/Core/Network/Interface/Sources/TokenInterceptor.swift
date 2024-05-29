//
//  TokenInterceptor.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/27/24.
//

import Combine
import CoreLocalStorageInterface
import Foundation

final public class TokenInterceptor: URLRequestInterceptor {
    private let oauthToken: String
    
    public init(oauthToken: String) {
        self.oauthToken = oauthToken
    }
    
    public func adapt(_ urlRequest: URLRequest) -> AnyPublisher<URLRequest, Error> {
        var request = urlRequest
        request.setValue(
            "Bearer \(oauthToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        return Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func retry(
        with session: URLSession,
        _ request: URLRequest,
        dueTo error: NetworkError
    ) -> AnyPublisher<RetryResult, Never> {
        // MARK: - 추후 토큰 만료시 여기서 재요청 후 tokenstorage에 저장해야 함.
        return Just(.doNotRetry)
            .eraseToAnyPublisher()
    }
}
