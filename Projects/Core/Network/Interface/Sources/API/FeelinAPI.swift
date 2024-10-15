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
    case signUp(request: UserSignUpRequest)
    case checkUserValidity(accessToken: String)
    case reissueAccessToken(refreshToken: String)
    case getArtists(pageNumber: Int, pageSize: Int)
    case searchArtists(pageNumber: Int, pageSize: Int, query: String)
    case postFavoriteArtists(ids: [Int])
    case postFavoriteArtist(id: Int)
    case deleteFavoriteArtist(id: Int)
    case getFavoriteArtists(cursor: Int?, size: Int)
    case getFavoriteArtistsRelatedNotes(cursor: Int?, size: Int, hasLyrics: Bool)
    case getFavoriteArtistsHavingNotes
    case postLikes(noteID: Int)
    case deleteLikes(noteID: Int)
    case postBookmarks(noteID: Int)
    case deleteBookmarks(noteID: Int)
    case deleteNote(noteID: Int)
    case getMyNotes(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int?)
    case getMyNotesByBookmark(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int?)
    case postNote(request: PostNoteRequest)
    case patchNote(noteID: Int, request: PatchNoteRequest)
    case searchSongs(cursor: Int, size: Int, query: String, artistID: Int)
    case getSearchedNotes(pageNumber: Int, pageSize: Int, query: String)
    case getSongNotes(cursor: Int?, size: Int, hasLyrics: Bool, songID: Int)
    case getArtistNotes(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int)
    case getNoteWithComments(noteID: Int)
    case postComment(body: PostCommentRequest)
    case deleteComment(commentID: Int)
    case reportNote(request: ReportRequest)
    case getNotifications(cursor: Int?, size: Int)
    case checkNotification(notificationID: Int)
    case getUserProfile
    case patchUserProfile(request: UserProfileRequest)
    case deleteUser
}

extension FeelinAPI: HTTPNetworking {

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
        case .getFavoriteArtists(let cursor, let size),
             .getNotifications(let cursor, let size):
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
            
        case .postLikes(let noteID),
             .deleteLikes(let noteID),
             .postBookmarks(let noteID),
             .deleteBookmarks(let noteID):
            return [
                "noteId": noteID
            ]

        case .searchSongs(let cursor, let size, let query, let artistID):
            return [
                "query": "\(query)",
                "cursor": "\(cursor)",
                "size": "\(size)",
                "artistId": "\(artistID)"
            ]

        case .searchArtists(let pageNumber, let pageSize, let query),
             .getSearchedNotes(let pageNumber, let pageSize, let query):
            return [
                "query": "\(query)",
                "pageNumber": "\(pageNumber)",
                "pageSize": "\(pageSize)"
            ]
            
        case .getArtists(let pageNumber, let pageSize):
            return [
                "pageNumber": pageNumber,
                "pageSize": pageSize
            ]
            
        case .getSongNotes(let cursor, let size, let hasLyrics, let songID):
            if let cursor = cursor {
                return [
                    "cursor": "\(cursor)",
                    "size": "\(size)",
                    "hasLyrics": "\(hasLyrics)",
                    "songId": "\(songID)"
                ]
            }
            
            return [
                "size": "\(size)",
                "hasLyrics": "\(hasLyrics)",
                "songId": "\(songID)"
            ]
            
        case .getArtistNotes(let cursor, let size, let hasLyrics, let artistID):
            if let cursor = cursor {
                return [
                    "cursor": "\(cursor)",
                    "size": "\(size)",
                    "hasLyrics": "\(hasLyrics)",
                    "artistId": "\(artistID)"
                ]
            }
            
            return [
                "size": "\(size)",
                "hasLyrics": "\(hasLyrics)",
                "artistId": "\(artistID)"
            ] 

        case .getMyNotes(let cursor, let size, let hasLyrics, let artistID),
             .getMyNotesByBookmark(let cursor, let size, let hasLyrics, let artistID):
            if let cursor = cursor, let artistID = artistID {
                return [
                    "cursor": "\(cursor)",
                    "size": "\(size)",
                    "hasLyrics": "\(hasLyrics)",
                    "artistId": "\(artistID)"
                ]
            }
            
            return [
                "size": "\(size)",
                "hasLyrics": "\(hasLyrics)"
            ]
        case .postFavoriteArtist(let id),
             .deleteFavoriteArtist(let id):
            return [
                "artistId": id
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

        // 건너뛰어서 출생연도, 성별이 없는 경우 encoding 되지 않음
        case .signUp(let request):
            return request

        case .postNote(let request):
            return request
            
        case .postComment(let postCommentBody):
            return postCommentBody

        case .reportNote(let request):
            return request

        case .patchUserProfile(let request):
            if let gender = request.gender?.rawValue,
               let birthYear = request.birthYear {
                return [
                    "nickname": request.nickname,
                    "profileCharacter": request.profileCharacter,
                    "gender": gender,
                    "birthYear": "\(birthYear)"
                ]
            }

            return [
                "nickname": request.nickname,
                "profileCharacter": request.profileCharacter
            ]

        case .patchNote(_, let request):
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
            
        case .getFavoriteArtists,
             .postFavoriteArtist,
             .deleteFavoriteArtist:
            return "/api/v1/favorite-artists"

        case .getFavoriteArtistsRelatedNotes:
            return "/api/v1/notes/favorite-artists"
            
        case .getFavoriteArtistsHavingNotes:
            return "/api/v1/favorite-artists/having-notes"

        case .postLikes,
             .deleteLikes:
            return "/api/v1/likes"
            
        case .postBookmarks, .deleteBookmarks:
            return "/api/v1/bookmarks"
            
        case .postNote, .getMyNotes:
		    return "/api/v1/notes"
        
        case .patchNote(let noteID, _):
            return "/api/v1/notes/\(noteID)"

        case .getMyNotesByBookmark:
            return "/api/v1/notes/bookmarked"

        case .searchSongs:
            return "/api/v1/songs/search/artists"
            
        case .deleteNote(let noteID),
             .getNoteWithComments(let noteID):
            return "/api/v1/notes/\(noteID)"
            
        case .getSearchedNotes:
            return "/api/v1/songs/search"
            
        case .getSongNotes:
            return "/api/v1/notes/songs"
            
        case .getArtistNotes:
            return "/api/v1/notes/artists"
            
        case .postComment:
            return "/api/v1/comments"
            
        case .deleteComment(let commentID):
            return "/api/v1/comments/\(commentID)"

        case .reportNote:
            return "/api/v1/reports"
            
        case .getNotifications:
            return "/api/v1/notifications"
            
        case .checkNotification(let notificationID):
            return "/api/v1/notifications/\(notificationID)"

        case .getUserProfile, .patchUserProfile:
            return "/api/v1/users"

        case .deleteUser:
            return "/api/v1/auth/delete"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .login,
             .reissueAccessToken,
             .signUp,
             .postFavoriteArtists,
             .postLikes,
             .postBookmarks,
             .postNote,
             .postComment, 
             .reportNote,
             .postFavoriteArtist:
            return .post

        case .checkUserValidity, 
             .getArtists,
             .searchArtists,
             .getFavoriteArtists,
             .getFavoriteArtistsRelatedNotes,
             .getFavoriteArtistsHavingNotes,
             .searchSongs,
             .getSearchedNotes,
             .getSongNotes,
             .getNoteWithComments,
             .getNotifications,
             .getArtistNotes,
             .getMyNotes,
             .getUserProfile,
             .getMyNotesByBookmark:
            return .get
            
        case .deleteLikes, 
             .deleteBookmarks,
             .deleteNote,
             .deleteComment,
             .deleteFavoriteArtist,
             .deleteUser :
            return .delete
            
        case .checkNotification,
             .patchUserProfile,
             .patchNote:
            return .patch
        }
    }
}
