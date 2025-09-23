//
//  NetworkSession.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 5/31/24.
//

import Combine
import Foundation

import Pulse

public typealias DataTaskResult = (data: Data, response: URLResponse)

open class NetworkSession {
    public let urlSession: URLSessionProtocol
    public var requestInterceptor: URLRequestInterceptor?
    
    public init(
        urlSession: URLSession = URLSession(configuration: .default),
        requestInterceptor: URLRequestInterceptor?
    ) {
        #if PROD
        self.urlSession = urlSession
        #else
        self.urlSession = URLSessionProxy(configuration: .default)
        #endif
        self.requestInterceptor = requestInterceptor
    }
    
    public func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<DataTaskResult, Error> {
        if let interceptor = requestInterceptor {
            return interceptor.adapt(request)
                .flatMap { [unowned self] adaptedRequest -> AnyPublisher<DataTaskResult, Error> in
                    return self._dataTaskPublisher(for: adaptedRequest)
                        .mapError { $0 as Error }
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
            
        } else {
            return self._dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
    }
}

// Pulse에서 제공하는 dataTaskPublisher를 사용할 경우 response 로그가 기록되지 않는 문제가 있음
// 반면, 다른 dataTask 메서드는 정상적으로 로그가 기록되므로
// 추후 이 부분이 해결되기 전까지 임시 방편으로 URLSessionProtocol의 dataTask를 Publisher로 감싸서 사용하여 문제를 해결.
private extension NetworkSession {
    func _dataTaskPublisher(for url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        _dataTaskPublisher(for: URLRequest(url: url))
    }

    func _dataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(URLError(.unknown)))
                return
            }
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error as? URLError ?? URLError(.unknown)))
                } else if let data = data, let response = response {
                    promise(.success((data: data, response: response)))
                } else {
                    promise(.failure(URLError(.badServerResponse)))
                }
            }
            task.resume()
        }
        .eraseToAnyPublisher()
    }
}
