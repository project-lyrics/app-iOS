//
//  Publisher+.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/7/24.
//

import Foundation
import Combine
import CoreNetworkInterface
import Shared

public extension Publisher where Output == DataTaskResult {
    func validateResponse(_ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<DataTaskResult, NetworkError> {
        return tryMap { data, response  in
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponseError
            }
            
            if let feelinServerFailResponse = try? decoder.decode(APIFailResponse.self, from: data) {
                throw NetworkError.feelinAPIError(
                    .init(apiFailResponse: feelinServerFailResponse)
                )
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
            let dateFormatter = DateFormatter()
            
            // MARK: - 2024.07.24 기획팀과 논의 된 시간 포맷에 따라서 아래와 같이 Date형식을 수정
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return try decoder.decode(outputType, from: $0.data)
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

// MARK: - Combine + Interceptor
extension Publisher where Output == DataTaskResult, Failure == NetworkError {
    func retryOnUnauthorized(
        session: NetworkSession,
        request: URLRequest
    ) -> AnyPublisher<Output, NetworkError> {
        return self.catch { networkError in
            guard let interceptor = session.requestInterceptor else {
                return Fail<Output, NetworkError>(error: networkError)
                    .eraseToAnyPublisher()
            }
            
            return interceptor.retry(
                with: session.urlSession,
                dueTo: networkError
            )
            .flatMap { result -> AnyPublisher<Output, NetworkError> in
                switch result {
                case .retry:
                    return session
                        .dataTaskPublisher(for: request)
                        .validateResponse()
                        .eraseToAnyPublisher()
                    
                case .doNotRetry:
                    return Fail(error: networkError)
                        .eraseToAnyPublisher()
                    
                case .doNotRetryWithError(let error):
                    return Fail(error: error)
                        .mapError({ error in
                            if let networkError = error as? NetworkError {
                                return networkError
                            } else {
                                return NetworkError.unknownError(error.localizedDescription)
                            }
                        })
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher {
    func withLatestFrom<P>(
        _ other: P
      ) -> AnyPublisher<(Self.Output, P.Output), Failure> where P: Publisher, Self.Failure == P.Failure {
        let other = other
          // Note: Do not use `.map(Optional.some)` and `.prepend(nil)`.
          // There is a bug in iOS versions prior 14.5 in `.combineLatest`. If P.Output itself is Optional.
          // In this case prepended `Optional.some(nil)` will become just `nil` after `combineLatest`.
          .map { (value: $0, ()) }
          .prepend((value: nil, ()))

        return map { (value: $0, token: UUID()) }
          .combineLatest(other)
          .removeDuplicates(by: { (old, new) in
            let lhs = old.0, rhs = new.0
            return lhs.token == rhs.token
          })
          .map { ($0.value, $1.value) }
          .compactMap { (left, right) in
            right.map { (left, $0) }
          }
          .eraseToAnyPublisher()
      }
}
