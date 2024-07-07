//
//  FeelinAPIError.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 7/6/24.
//

import Foundation

public enum FeelinAPIError: LocalizedError, Equatable {
    case invalidRequest(errorMessage: String)
    case invalidRequestInput(errorMessage: String)
    case unexpectedServerError(errorMessage: String)
    case refreshTokenNotFound(errorMessage: String)
    case tokenIsExpired(errorMessage: String)
    case wrongTokenTypePassed(errorMessage: String)
    case unsupportedAuthProvider(errorMessage: String)
    case invalidToken(errorMessage: String)
    case invalidPublicKey(errorMessage: String)
    case invalidSecretKey(errorMessage: String)
    case userDataNotFound(errorMessage: String)
    case artistDataNotFound(errorMessage: String)
    case dataFailedValidation(errorMessage: String)
    case recordDataNotFound(errorMessage: String)
    case unknown(errorCode: String, errorMessage: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidRequest(let errorMessage),
             .invalidRequestInput(let errorMessage),
             .unexpectedServerError(let errorMessage),
             .refreshTokenNotFound(let errorMessage),
             .tokenIsExpired(let errorMessage),
             .wrongTokenTypePassed(let errorMessage),
             .unsupportedAuthProvider(let errorMessage),
             .invalidToken(let errorMessage),
             .invalidPublicKey(let errorMessage),
             .invalidSecretKey(let errorMessage),
             .userDataNotFound(let errorMessage),
             .artistDataNotFound(let errorMessage),
             .dataFailedValidation(let errorMessage),
             .recordDataNotFound(let errorMessage),
             .unknown(_, let errorMessage):
            return errorMessage
        }
    }
    
    public init(apiFailResponse: APIFailResponse) {
        switch apiFailResponse.errorCode {
        case "00000":
            self = .invalidRequest(errorMessage: apiFailResponse.errorMessage)
        case "00001":
            self = .invalidRequestInput(errorMessage: apiFailResponse.errorMessage)
        case "00002":
            self = .unexpectedServerError(errorMessage: apiFailResponse.errorMessage)
        case "01000":
            self = .refreshTokenNotFound(errorMessage: apiFailResponse.errorMessage)
        case "01001":
            self = .tokenIsExpired(errorMessage: apiFailResponse.errorMessage)
        case "01002":
            self = .wrongTokenTypePassed(errorMessage: apiFailResponse.errorMessage)
        case "01003":
            self = .unsupportedAuthProvider(errorMessage: apiFailResponse.errorMessage)
        case "01004":
            self = .invalidToken(errorMessage: apiFailResponse.errorMessage)
        case "01005":
            self = .invalidPublicKey(errorMessage: apiFailResponse.errorMessage)
        case "01006":
            self = .invalidSecretKey(errorMessage: apiFailResponse.errorMessage)
        case "02000":
            self = .userDataNotFound(errorMessage: apiFailResponse.errorMessage)
        case "03000":
            self = .artistDataNotFound(errorMessage: apiFailResponse.errorMessage)
        case "03001":
            self = .dataFailedValidation(errorMessage: apiFailResponse.errorMessage)
        case "04000":
            self = .recordDataNotFound(errorMessage: apiFailResponse.errorMessage)
        default:
            self = .unknown(errorCode: apiFailResponse.errorCode, errorMessage: apiFailResponse.errorMessage)
        }
    }
}
