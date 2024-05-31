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
    private let networkSession: NetworkSession

    public init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }

    public func request<N: HTTPNetworking, T: Decodable>(
        _ endpoint: N
    ) -> AnyPublisher<T, NetworkError> where N.Response == T {
        do {
            let urlRequest: URLRequest = try endpoint.makeURLRequest()

            return networkSession
                .dataTaskPublisher(for: urlRequest)
                .tryDecodeAPIFailResponse()
                .validateStatusCode()
                .retryOnUnauthorized(
                    session: networkSession,
                    request: urlRequest
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
