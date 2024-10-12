//
//  FeelinAPIError.swift
//  CoreNetworkInterface
//
//  Created by 황인우 on 7/6/24.
//

import Foundation

public enum FeelinAPIError: LocalizedError, Equatable {
    case invalidRequest(errorCode: String, errorMessage: String)
    case invalidRequestInput(errorCode: String, errorMessage: String)
    case unexpectedServerError(errorCode: String, errorMessage: String)
    case refreshTokenNotFound(errorCode: String, errorMessage: String)
    case tokenIsExpired(errorCode: String, errorMessage: String)
    case wrongTokenTypePassed(errorCode: String, errorMessage: String)
    case unsupportedAuthProvider(errorCode: String, errorMessage: String)
    case invalidToken(errorCode: String, errorMessage: String)
    case invalidPublicKey(errorCode: String, errorMessage: String)
    case invalidSecretKey(errorCode: String, errorMessage: String)
    case userDataNotFound(errorCode: String, errorMessage: String)
    case artistDataNotFound(errorCode: String, errorMessage: String)
    case dataFailedValidation(errorCode: String, errorMessage: String)
    case recordDataNotFound(errorCode: String, errorMessage: String)
    case tokenNotFound(errorCode: String, errorMessage: String)
    case unknown(errorCode: String, errorMessage: String)

    public var errorCode: String {
        switch self {
        case .invalidRequest(let errorCode, _),
                .invalidRequestInput(let errorCode, _),
                .unexpectedServerError(let errorCode, _),
                .refreshTokenNotFound(let errorCode, _),
                .tokenIsExpired(let errorCode, _),
                .wrongTokenTypePassed(let errorCode, _),
                .unsupportedAuthProvider(let errorCode, _),
                .invalidToken(let errorCode, _),
                .invalidPublicKey(let errorCode, _),
                .invalidSecretKey(let errorCode, _),
                .userDataNotFound(let errorCode, _),
                .artistDataNotFound(let errorCode, _),
                .dataFailedValidation(let errorCode, _),
                .recordDataNotFound(let errorCode, _),
                .tokenNotFound(let errorCode, _),
                .unknown(let errorCode, _):
            return errorCode
        }
    }

    public var errorMessage: String {
        switch self {
        case .invalidRequest(_, let errorMessage),
                .invalidRequestInput(_, let errorMessage),
                .unexpectedServerError(_, let errorMessage),
                .refreshTokenNotFound(_, let errorMessage),
                .tokenIsExpired(_, let errorMessage),
                .wrongTokenTypePassed(_, let errorMessage),
                .unsupportedAuthProvider(_, let errorMessage),
                .invalidToken(_, let errorMessage),
                .invalidPublicKey(_, let errorMessage),
                .invalidSecretKey(_, let errorMessage),
                .userDataNotFound(_, let errorMessage),
                .artistDataNotFound(_, let errorMessage),
                .dataFailedValidation(_, let errorMessage),
                .recordDataNotFound(_, let errorMessage),
                .tokenNotFound(_, let errorMessage),
                .unknown(_, let errorMessage):
            return errorMessage
        }
    }

    public init(apiFailResponse: APIFailResponse) {
        switch apiFailResponse.errorCode {
        case "00000":
            self = .invalidRequest(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "00001":
            self = .invalidRequestInput(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "00002":
            self = .unexpectedServerError(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01000":
            self = .refreshTokenNotFound(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01001":
            self = .tokenIsExpired(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01002":
            self = .wrongTokenTypePassed(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01003":
            self = .unsupportedAuthProvider(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01004":
            self = .invalidToken(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01005":
            self = .invalidPublicKey(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01006":
            self = .invalidSecretKey(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "01008":
            self = .tokenNotFound(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
            
        case "02000":
            self = .userDataNotFound(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "03000":
            self = .artistDataNotFound(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "03001":
            self = .dataFailedValidation(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        case "04000":
            self = .recordDataNotFound(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        default:
            self = .unknown(
                errorCode: apiFailResponse.errorCode,
                errorMessage: apiFailResponse.errorMessage
            )
        }
    }
}
