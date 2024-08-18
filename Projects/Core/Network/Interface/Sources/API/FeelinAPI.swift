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
    case getFavoriteArtistsRelatedNotes(cursor: Int?, size: Int, hasLyrics: Bool)
    case postLikes(noteID: Int)
    case deleteLikes(noteID: Int)
    case postBookmarks(noteID: Int)
    case deleteBookmarks(noteID: Int)
    case deleteNote(noteID: Int)
    case postNote(request: PostNoteRequest)
}

extension FeelinAPI: HTTPNetworking {

    public typealias Response = R

    public var baseURL: String? {
        guard let baseURL = Bundle.main.infoDictionary?["Feelin_URL"] as? String else {
            return "http://api.feelinapp.com:8080"
        }

        return baseURL
    }

    public var path: String {
        switch self {
        case .login:                    return "/api/v1/auth/sign-in"
        case .signUp:                   return "/api/v1/auth/sign-up"
        case .checkUserValidity:        return "/api/v1/auth/validate-token"
        case .reissueAccessToken:       return "/api/v1/auth/token"
        case .getArtists:               return "/api/v1/artists"
        case .searchArtists:            return "/api/v1/artists/search"
        case .postFavoriteArtists:      return "/api/v1/favorite-artists/batch"
        case .postNote:                 return "/api/v1/notes"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .login, .reissueAccessToken, .signUp, .postFavoriteArtists, .postNote:
            return .post

        case .checkUserValidity, .getArtists, .searchArtists:
            return .get
        }
    }

    public var headers: [String : String]? {
        var defaultHeader = ["Content-Type": "application/json"]

        switch self {
        case .checkUserValidity(let accessToken):
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
                .getFavoriteArtists(let cursor, let size):
            if let cursor = cursor {
                return [
                    "cursor": cursor,
                    "size": size
                ]
            }

            return [
                "size": size
            ]
        
        case .getFavoriteArtistsRelatedNotes(let cursor, let size, let hasLyrics):
            if let cursor = cursor {
                return [
                    "cursor": "\(cursor)",
                    "size": "\(size)",
                    "hasLyrics": "\(hasLyrics)"
                ]
            }
            
            return [
                "size": "\(size)",
                "hasLyrics": "\(hasLyrics)"
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
            
        case .postLikes(let noteID),
                .deleteLikes(let noteID),
                .postBookmarks(let noteID),
                .deleteBookmarks(let noteID),
                .deleteNote(let noteID):
            return [
                "noteId": noteID
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

        case .postNote(let request):
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
            
        case .getFavoriteArtistsRelatedNotes:
            return "/api/v1/notes/favorite-artists"
            
        case .postLikes, .deleteLikes:
            return "/api/v1/likes"
            
        case .postBookmarks, .deleteBookmarks:
            return "/api/v1/bookmarks"
            
        case .deleteNote:
            return "/api/v1/notes/"
        case .postNote:                 
		    return "/api/v1/notes"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .login, .reissueAccessToken, .signUp, .postFavoriteArtists, .postLikes, .postBookmarks, .postNote:
            return .post

        case .checkUserValidity, .getArtists, .searchArtists, .getFavoriteArtists, .getFavoriteArtistsRelatedNotes:
            return .get
            
        case .deleteLikes, .deleteBookmarks, .deleteNote:
            return .delete
        }
    }
}
