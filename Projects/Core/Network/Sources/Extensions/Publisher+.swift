//
//  Publisher+.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 4/7/24.
//

import Foundation
import Combine
import CoreNetworkInterface

public typealias DataTaskResult = (data: Data, response: URLResponse)

public extension Publisher where Output == DataTaskResult {
    func validateStatusCode() -> AnyPublisher<DataTaskResult, NetworkError> {
        return tryMap { data, response  in
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponseError
            }

            switch response.statusCode {
            case 200..<300:
                return DataTaskResult(
                    data: data,
                    response: response
                )

            case 400..<451:
                throw NetworkError.clientError(
                    NetworkError.ClientError(rawValue: response.statusCode) ?? .badRequestError
                )

            case 500..<512:
                throw NetworkError.serverError(
                    NetworkError.ServerError(rawValue: response.statusCode) ?? .internalServerError
                )

            default:
                throw NetworkError.unknownError("Response Unknown Error: \(response.statusCode)")
            }
        }
        .mapError { error in
            if let networkError = error as? NetworkError {
                return networkError
            } else {
                return NetworkError.unknownError(error.localizedDescription)
            }
        }
        .eraseToAnyPublisher()
    }

    func validateJSONValue<Output: Decodable>(to outputType: Output.Type) -> AnyPublisher<Output, NetworkError> {
        return tryMap {
            try JSONDecoder().decode(outputType, from: $0.data)
        }
        .mapError { error in
            switch error {
            case let decodingError as DecodingError:
                return NetworkError.decodingError(decodingError.localizedDescription)
            case let networkError as NetworkError:
                return networkError
            default:
                return NetworkError.unknownError(error.localizedDescription)
            }
        }
        .eraseToAnyPublisher()
    }

    func debug(prefix: String = "") -> Publishers.Print<Self> {
        return print(prefix + "publisher", to: CombineTimeLogger())
    }
}
