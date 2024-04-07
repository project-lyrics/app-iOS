//
//  NetworkError.swift
//  CoreNetworkInterface
//
//  Created by Derrick kim on 4/7/24.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case urlRequestError(URLRequestError)
    case invalidURLError
    case noResponseError
    case badRequestError
    case authorizationError
    case forbiddenError
    case notFoundError
    case methodNotAllowed
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case uriTooLong
    case unsupportedMediaType
    case requestedRangeNotSatisfiable
    case expectationFailed
    case misdirectedRequest
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired
    case preconditionRequired
    case tooManyRequests
    case requestHeaderFieldsTooLarge
    case unavailableForLegalReasons
    case internalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired
    case decodingError( _ description: String)
    case unknownError( _ description: String)

    public var errorMessage: String {
        switch self {
        case let .urlRequestError(urlRequestError):     return urlRequestError.errorMessage
        case .decodingError:                            return "Decoding Error"
        case .invalidURLError:                          return "Invalid URL"
        case .noResponseError:                          return "No Response"
        case .forbiddenError:                           return "Forbidden Error"
        case .notFoundError:                            return "Not Found Error"
        case .methodNotAllowed:                         return "Method Not Allowed"
        case .requestTimeout:                           return "Request Timeout"
        case .conflict:                                 return "Conflict"
        case .internalServerError:                      return "Internal Server Error"
        case .notImplemented:                           return "Not Implemented"
        case .authorizationError:                       return "Authorization Error"
        case .badRequestError:                          return "Bad Request From Client"
        case .unknownError:                             return "Unknown Error"
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
