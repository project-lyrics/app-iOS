//
//  NetworkError.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 4/7/24.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case urlRequestError(URLRequestError)
    case clientError(ClientError)
    case serverError(ServerError)
    case noResponseError
    case decodingError( _ description: String)
    case unknownError( _ description: String)

    public var errorMessage: String {
        switch self {
        case let .urlRequestError(urlRequestError):     return urlRequestError.errorMessage
        case let .clientError(clientError):             return clientError.errorMessage
        case let .serverError(serverError):             return serverError.errorMessage
        case .noResponseError:                          return "No Response"
        case .decodingError:                            return "Decoding Error"
        case .unknownError:                             return "Unknown Error"
        }
    }

    public enum URLRequestError: Error {
        case urlComponentError
        case queryEncodingError
        case bodyEncodingError
        case makeURLError

        public var errorMessage: String {
            switch self {
            case .urlComponentError:        return "urlComponentError"
            case .queryEncodingError:       return "queryEncodingError"
            case .bodyEncodingError:        return "queryEncodingError"
            case .makeURLError:             return "makeURLError"
            }
        }
    }

    public enum ClientError: Int, Error {
        case badRequestError = 400
        case authorizationError = 401
        case forbiddenError = 403
        case notFoundError = 404
        case methodNotAllowed = 405
        case requestTimeout = 408
        case conflict = 409
        case gone = 410
        case lengthRequired = 411
        case preconditionFailed = 412
        case payloadTooLarge = 413
        case uriTooLong = 414
        case unsupportedMediaType = 415
        case requestedRangeNotSatisfiable = 416
        case expectationFailed = 417
        case misdirectedRequest = 421
        case unprocessableEntity = 422
        case locked = 423
        case failedDependency = 424
        case upgradeRequired = 426
        case preconditionRequired = 428
        case tooManyRequests = 429
        case requestHeaderFieldsTooLarge = 431
        case unavailableForLegalReasons = 451

        public var errorMessage: String {
            switch self {
            case .forbiddenError:                           return "Forbidden Error"
            case .notFoundError:                            return "Not Found Error"
            case .methodNotAllowed:                         return "Method Not Allowed"
            case .requestTimeout:                           return "Request Timeout"
            case .conflict:                                 return "Conflict"
            case .authorizationError:                       return "Authorization Error"
            case .badRequestError:                          return "Bad Request From Client"
            case .gone:                                     return "Gone"
            case .lengthRequired:                           return "Length Required"
            case .preconditionFailed:                       return "Precondition Failed"
            case .payloadTooLarge:                          return "Payload Too Large"
            case .uriTooLong:                               return "URI Too Long"
            case .unsupportedMediaType:                     return "Unsupported Media Type"
            case .requestedRangeNotSatisfiable:             return "Requested Range Not Satisfiable"
            case .expectationFailed:                        return "Expectation Failed"
            case .misdirectedRequest:                       return "Misdirected Request"
            case .unprocessableEntity:                      return "Unprocessable Entity"
            case .locked:                                   return "Locked"
            case .failedDependency:                         return "Failed Dependency"
            case .upgradeRequired:                          return "Upgraded Required"
            case .preconditionRequired:                     return "Precondition Required"
            case .tooManyRequests:                          return "Too Many Requests"
            case .requestHeaderFieldsTooLarge:              return "Request Header Fields Too Large"
            case .unavailableForLegalReasons:               return "Unavailable For Legal Reasons"
            }
        }
    }

    public enum ServerError: Int, Error {
        case internalServerError = 500
        case notImplemented = 501
        case badGateway = 502
        case serviceUnavailable = 503
        case gatewayTimeout = 504
        case httpVersionNotSupported = 505
        case variantAlsoNegotiates = 506
        case insufficientStorage = 507
        case loopDetected = 508
        case notExtended = 510
        case networkAuthenticationRequired = 511

        public var errorMessage: String {
            switch self {
            case .internalServerError:                      return "Internal Server Error"
            case .notImplemented:                           return "Not Implemented"
            case .badGateway:                               return "Bad Gateway"
            case .serviceUnavailable:                       return "Service Unavailable"
            case .gatewayTimeout:                           return "Gateway Timeout"
            case .httpVersionNotSupported:                  return "HTTP Version Not Supported"
            case .variantAlsoNegotiates:                    return "Variant Also Negotiates"
            case .insufficientStorage:                      return "Insufficient Storage"
            case .loopDetected:                             return "Loop Detected"
            case .notExtended:                              return "Not Extended"
            case .networkAuthenticationRequired:            return "Network Authentication Required"
            }
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.errorMessage == rhs.errorMessage
    }
}
