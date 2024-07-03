//
//  FeelinAPI.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//


import Foundation

public enum FeelinAPI<R> {
    case login(
        oauthProvider: OAuthProvider,
        oauthAccessToken: String
    )
    case checkUserValidity
    case reissueAccessToken(refreshToken: String)
}

extension FeelinAPI: HTTPNetworking {
    public var headers: [String : String]? {
        var defaultHeader = ["application/json": "Content-Type"]

        switch self {
        case .login(_, oauthAccessToken: let oAuthAccessToken):
            defaultHeader["Authorization"] = "Bearer \(oAuthAccessToken)"

        case .reissueAccessToken(refreshToken: let refreshToken):
            defaultHeader["Authorization"] = "Bearer \(refreshToken)"

        default:
            return defaultHeader
        }

        return defaultHeader
    }

    public var queryParameters: Encodable? {
        return nil
    }

    public var bodyParameters: Encodable? {
        switch self {
        case .login(let oauthProvider, let oauthAccessToken):
            return [
                "socialAccessToken": oauthAccessToken,
                "authProvider": oauthProvider.rawValue
            ]

        default:
            return nil
        }
    }

    public typealias Response = R

    public var baseURL: String? {
        guard let baseURL = Bundle.main.infoDictionary?["Feelin_URL"] as? String else {
            return "http://api.feelinapp.com:8080"
        }

        return baseURL
    }

    public var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/sign-in"

        case .checkUserValidity:
            return "/api/v1/auth/token"

        case .reissueAccessToken:
            return "/api/v1/auth/token"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .login, .reissueAccessToken:
            return .post

        case .checkUserValidity:
            return .get
        }
    }
}
