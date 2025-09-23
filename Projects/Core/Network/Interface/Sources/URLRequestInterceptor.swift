//
//  URLRequestInterceptor.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/26/24.
//

import Combine
import Foundation

import Pulse

public enum RetryResult {
    case retry
    case doNotRetry
    case doNotRetryWithError(Error)
}

public protocol URLRequestInterceptor: AnyObject {
    func adapt(_ urlRequest: URLRequest) -> AnyPublisher<URLRequest, Error>
    func retry(
        with session: URLSessionProtocol,
        dueTo error: NetworkError
    ) -> AnyPublisher<RetryResult, Never>
}
