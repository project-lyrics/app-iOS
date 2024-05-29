//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import CoreNetworkInterface
import Combine
import SharedUtil

public final class NetworkProvider: NetworkProviderProtocol {
    private let session: URLSession
    private let requestInterceptor: URLRequestInterceptor?

    public init(
        session: URLSession = URLSession.shared,
        requestInterceptor: URLRequestInterceptor? = nil
    ) {
        self.session = session
        self.requestInterceptor = requestInterceptor
    }

    public func request<N: HTTPNetworking, T: Decodable>(
        _ endpoint: N
    ) -> AnyPublisher<T, NetworkError> where N.Response == T {
        do {
            let urlRequest: URLRequest = try endpoint.makeURLRequest()

            return session
                .dataTaskPublisher(
                    for: urlRequest,
                    interceptor: self.requestInterceptor
                )
                .tryDecodeAPIFailResponse()
                .validateStatusCode()
                .retryOnUnauthorized(
                    session: session,
                    request: urlRequest,
                    using: requestInterceptor
                )
                .validateJSONValue(to: T.self)
                .eraseToAnyPublisher()
        } catch let error as NetworkError {
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        } catch let error as URLError {
            return Fail(error: NetworkError.urlError(error))
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: NetworkError.unknownError(error.localizedDescription))
                .eraseToAnyPublisher()
        }
    }
}
