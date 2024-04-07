//
//  Publisher+.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 4/7/24.
//

import Foundation
import Combine
import SharedUtil
import CoreNetworkInterface

public typealias DataTaskResult = (data: Data, response: URLResponse)

public extension Publisher where Output == DataTaskResult {
    func validateStatusCode() -> AnyPublisher<DataTaskResult, NetworkError> {
        return tryMap { data, response  in
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponseError
            }

            switch response.statusCode {
            case 200..<300:         return DataTaskResult(data : data, response: response)
            case 400:               throw NetworkError.badRequestError
            case 401:               throw NetworkError.authorizationError
            case 403:               throw NetworkError.forbiddenError
            case 404:               throw NetworkError.notFoundError
            case 405:               throw NetworkError.methodNotAllowed
            case 408:               throw NetworkError.requestTimeout
            case 409:               throw NetworkError.conflict
            case 410:               throw NetworkError.gone
            case 411:               throw NetworkError.lengthRequired
            case 412:               throw NetworkError.preconditionFailed
            case 413:               throw NetworkError.payloadTooLarge
            case 414:               throw NetworkError.uriTooLong
            case 415:               throw NetworkError.unsupportedMediaType
            case 416:               throw NetworkError.requestedRangeNotSatisfiable
            case 417:               throw NetworkError.expectationFailed
            case 421:               throw NetworkError.misdirectedRequest
            case 422:               throw NetworkError.unprocessableEntity
            case 423:               throw NetworkError.locked
            case 424:               throw NetworkError.failedDependency
            case 426:               throw NetworkError.upgradeRequired
            case 428:               throw NetworkError.preconditionRequired
            case 429:               throw NetworkError.tooManyRequests
            case 431:               throw NetworkError.requestHeaderFieldsTooLarge
            case 451:               throw NetworkError.unavailableForLegalReasons
            case 500:               throw NetworkError.internalServerError
            case 501:               throw NetworkError.notImplemented
            case 502:               throw NetworkError.badGateway
            case 503:               throw NetworkError.serviceUnavailable
            case 504:               throw NetworkError.gatewayTimeout
            case 505:               throw NetworkError.httpVersionNotSupported
            case 506:               throw NetworkError.variantAlsoNegotiates
            case 507:               throw NetworkError.insufficientStorage
            case 508:               throw NetworkError.loopDetected
            case 510:               throw NetworkError.notExtended
            case 511:               throw NetworkError.networkAuthenticationRequired
            default:                throw NetworkError.unknownError("Response Unknown Error")
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
