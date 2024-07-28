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
    case getArtists(cursor: Int?, size: Int)
    case searchArtists(query: String, cursor: Int?, size: Int)
    case postFavoriteArtists(ids: [Int])
}

extension FeelinAPI: HTTPNetworking {
    public var headers: [String : String]? {
        var defaultHeader = ["Content-Type": "application/json"]

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
        switch self {
        case .getArtists(let cursor, let size):
            if let cursor = cursor {
                return [
                    "cursor": cursor,
                    "size": size
                ]
            }
            
            return [
                "size": size
            ]
        case .searchArtists(let query, let cursor, let size):
            if let cursor = cursor {
                return [
                    "query": "\(query)",
                    "cursor": "\(cursor)",
                    "size": "\(size)"
                ]
            }
            
            return [
                "query": "\(query)",
                "size": "\(size)"
            ]
            
        default:
            return nil
        }
        
    }

    public var bodyParameters: Encodable? {
        switch self {
        case .login(let oauthProvider, let oauthAccessToken):
            return [
                "socialAccessToken": oauthAccessToken,
                "authProvider": oauthProvider.rawValue
            ]
            
        case .postFavoriteArtists(let ids):
            return [
                "artistIds": ids
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
            
        case .getArtists:
            return "/api/v1/artists"
            
        case .searchArtists:
            return "/api/v1/artists/search"
            
        case .postFavoriteArtists:
            return "/api/v1/favorite-artists/batch"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .login, .reissueAccessToken, .postFavoriteArtists:
            return .post

        case .checkUserValidity, .getArtists, .searchArtists:
            return .get
        }
    }
}
