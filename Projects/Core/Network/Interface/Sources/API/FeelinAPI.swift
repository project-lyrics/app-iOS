//
//  FeelinAPI.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//


import Foundation

public enum FeelinAPI<R> {
    case login(
        oAuthProvider: OAuthProvider,
        oAuthAccessToken: String
    )
    case signUp(request: UserSignUpRequest?)
    case checkUserValidity(accessToken: String)
    case reissueAccessToken(refreshToken: String)
    case getArtists(cursor: Int?, size: Int)
    case searchArtists(query: String, cursor: Int?, size: Int)
    case postFavoriteArtists(ids: [Int])
    case getFavoriteArtists(cursor: Int?, size: Int)
    case getNotes(cursor: Int?, size: Int)
}

extension FeelinAPI: HTTPNetworking {
    public var headers: [String : String]? {
        var defaultHeader = ["Content-Type": "application/json"]

        switch self {
        case .checkUserValidity(accessToken: let accessToken):
            return [
                "Authorization" : "Bearer \(accessToken)"
            ]

        case .reissueAccessToken(refreshToken: let refreshToken):
            defaultHeader["Authorization"] = "Bearer \(refreshToken)"

        default:
            return defaultHeader
        }

        return defaultHeader
    }

    public var queryParameters: Encodable? {
        switch self {
        case .getArtists(let cursor, let size),
                .getFavoriteArtists(let cursor, let size),
                .getNotes(let cursor, let size):
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
        case .login(let oAuthProvider, let oAuthAccessToken):
            return [
                "socialAccessToken": oAuthAccessToken,
                "authProvider": oAuthProvider.rawValue
            ]
            
        case .postFavoriteArtists(let ids):
            return [
                "artistIds": ids
            ]

        case .signUp(let request):
            return request

        default:
            return nil
        }
    }

    public typealias Response = R

    public var baseURL: String? {
        guard let baseURL = Bundle.main.infoDictionary?["Feelin_URL"] as? String else {
            return "http://api.feelinapp.com"
        }

        return baseURL
    }

    public var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/sign-in"

        case .signUp:
            return "/api/v1/auth/sign-up"

        case .checkUserValidity:
            return "/api/v1/auth/validate-token"

        case .reissueAccessToken:
            return "/api/v1/auth/token"
            
        case .getArtists:
            return "/api/v1/artists"
            
        case .searchArtists:
            return "/api/v1/artists/search"
            
        case .postFavoriteArtists:
            return "/api/v1/favorite-artists/batch"
            
        case .getFavoriteArtists:
            return "/api/v1/favorite-artists"
            
        case .getNotes:
            return "/api/v1/notes"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .login, .reissueAccessToken, .signUp, .postFavoriteArtists:
            return .post

        case .checkUserValidity, .getArtists, .searchArtists, .getFavoriteArtists, .getNotes:
            return .get
        }
    }
}
