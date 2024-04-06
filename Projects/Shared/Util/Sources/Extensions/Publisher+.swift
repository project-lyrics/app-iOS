//
//  Publisher+.swift
//  SharedUtil
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import Combine
import SharedUtilInterface

public typealias DataTaskResult = (data: Data, response: URLResponse)

public extension Publisher where Output == DataTaskResult {
    func validateStatusCode() -> AnyPublisher<DataTaskResult, NetworkError> {
        return tryMap { data, response  in
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponseError
            }

            switch response.statusCode {
            case 200..<300:
                return DataTaskResult(data : data, response: response)

            case 400:
                throw NetworkError.badRequestError

            case 401:
                throw NetworkError.authorizationError

            case 403:
                throw NetworkError.forbiddenError

            case 404:
                throw NetworkError.notFoundError

            case 500:
                throw NetworkError.serverError

            default:
                throw NetworkError.unknownError
            }
        }
        .mapError { error in
            if let networkError = error as? NetworkError {
                return networkError
            } else {
                return NetworkError.unknownError
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
                return NetworkError.unknownError
            }
        }
        .eraseToAnyPublisher()
    }

    func debug(prefix: String = "") -> Publishers.Print<Self> {
        return print(prefix + "publisher", to: CombineTimeLogger())
    }
}
