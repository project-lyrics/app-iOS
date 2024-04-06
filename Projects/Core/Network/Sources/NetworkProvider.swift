//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import CoreNetworkInterface
import Combine
import SharedUtilInterface

public final class NetworkProvider: NetworkProviderProtocol {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func request<N: HTTPNetworking, T: Decodable>(
        _ endpoint: N
    ) -> AnyPublisher<T, NetworkError> where N.Response == T {
        do {
            let urlRequest: URLRequest = try endpoint.makeURLRequest()

            return session
                .dataTaskPublisher(for: urlRequest)
                .validateStatusCode()
                .receive(on: DispatchQueue.main)
                .validateJSONValue(to: T.self)
                .eraseToAnyPublisher()
        } catch let error {
            if let networkError = error as? NetworkError {
                return Fail(error: networkError)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: NetworkError.unknownError)
                    .eraseToAnyPublisher()
            }
        }
    }
}
