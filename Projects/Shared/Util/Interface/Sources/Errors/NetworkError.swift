//
//  NetworkError.swift
//  SharedUtilInterface
//
//  Created by Derrick kim on 4/4/24.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case urlRequestError(URLRequestError)
    case invalidURLError
    case noResponseError
    case forbiddenError
    case notFoundError
    case serverError
    case decodingError( _ description: String)
    case badRequestError
    case authorizationError
    case unknownError

    public var errorMessage: String {
        switch self {
        case let .urlRequestError(urlRequestError):
            return urlRequestError.errorMessage
        case .decodingError:
            return "Decoding Error"
        case .invalidURLError:
            return "Invalid URL"
        case .noResponseError:
            return "No Response"
        case .forbiddenError:
            return "Forbidden Error"
        case .notFoundError:
            return "Not Found Error"
        case .serverError:
            return "Server Error"
        case .authorizationError:
            return "Authorization Error"
        case .badRequestError:
            return "Bad Request From Client"
        case .unknownError:
            return "Unknown Error"
        }
    }

    public enum URLRequestError: Error {
        case urlComponentError
        case queryEncodingError
        case bodyEncodingError
        case makeURLError

        public var errorMessage: String {
            switch self {
            case .urlComponentError:
                return "urlComponentError"
            case .queryEncodingError:
                return "queryEncodingError"
            case .bodyEncodingError:
                return "queryEncodingError"
            case .makeURLError:
                return "makeURLError"
            }
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.errorMessage == rhs.errorMessage
    }
}
