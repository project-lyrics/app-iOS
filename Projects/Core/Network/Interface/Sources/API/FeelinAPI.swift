//
//  FeelinAPI.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Shared

import Foundation
import UIKit.UIDevice

public enum FeelinAPI<R> {
    case login(
        oAuthProvider: OAuthProvider,
        oAuthAccessToken: String
    )
    case signUp(request: UserSignUpRequest)
    case checkUserValidity(accessToken: String)
    case reissueAccessToken(refreshToken: String)
    case getArtists(pageNumber: Int, pageSize: Int)
    case getArtist(artistID: Int)
    case getIsFavoriteArtist(artistID: Int)
    case searchArtists(pageNumber: Int, pageSize: Int, query: String)
    case postFavoriteArtists(ids: [Int])
    case postFavoriteArtist(id: Int)
    case deleteFavoriteArtist(id: Int)
    case getFavoriteArtists(cursor: Int?, size: Int)
    case getFavoriteArtistsRelatedNotes(cursor: Int?, size: Int, hasLyrics: Bool)
    case getFavoriteArtistsHavingNotes
    case getFavoriteArtistsBookmarked
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
    case getSongDetail(songID: Int)
    case getSongNotes(cursor: Int?, size: Int, hasLyrics: Bool, songID: Int)
    case getArtistNotes(cursor: Int?, size: Int, hasLyrics: Bool, artistID: Int)
    case getNoteWithComments(noteID: Int)
    case postComment(body: PostCommentRequest)
    case deleteComment(commentID: Int)
    case reportNote(request: ReportRequest)
    case getPersonalNotifications(cursor: Int?, size: Int)
    case getPublicNotifications(cursor: Int?, size: Int)
    case checkNotification(notificationID: Int)
    case getHasUncheckedNotification
    case getUserProfile
    case patchUserProfile(request: UserProfileRequest)
    case postBlockUserProfile(userID: Int)
    case deleteBlockUserProfile(userID: Int)
    case getBlockedUsers
    case deleteUser
    case checkFirstVisitor
    case getEvents
    case postEventRefuse(eventID: Int)
    case getBanners
}

extension FeelinAPI: HTTPNetworking {

    public var headers: [String : String]? {
        var defaultHeader = ["Content-Type": "application/json"]

        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            defaultHeader["Device-Id"] = deviceID
        }
        
        if let appVersion = Bundle.main.appVersion {
            defaultHeader["App-Version"] = appVersion
        }
        
        switch self {
        case .checkUserValidity(let accessToken):
            defaultHeader["Authorization"] = "Bearer \(accessToken)"
        default:
            return defaultHeader
        }
        
        return defaultHeader
    }

    public var queryParameters: Encodable? {
        switch self {
        case .getFavoriteArtists(let cursor, let size),
             .getPersonalNotifications(let cursor, let size),
             .getPublicNotifications(let cursor, let size):
            if let cursor = cursor {
                return [
                    "cursor": cursor,
                    "size": size
                ]
            }

            return [
                "size": size
            ]
            
        case .getIsFavoriteArtist(let artistID):
            return [
                "artistId": artistID
            ]
        
        case .getFavoriteArtistsRelatedNotes(let cursor, let size, let hasLyrics):
            if let cursor = cursor {
                return [
                    "cursor": "\(cursor)",
                    "size": "\(size)",
                    "hasLyrics": "\(hasLyrics)",
                    "isFavoriteArtistsOnly": "true"
                ]
            }

            return [
                "size": "\(size)",
                "hasLyrics": "\(hasLyrics)",
                "isFavoriteArtistsOnly": "true"
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
            
        case .postBlockUserProfile(let userID),
             .deleteBlockUserProfile(let userID):
            return [
                "userId": userID
            ]
            
        case .postEventRefuse(let eventID):
            return [
                "eventId": eventID
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
            
        case .reissueAccessToken(refreshToken: let refreshToken):
            return [
                "refreshToken": refreshToken
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

        // 프로필 수정API - 수정하지 않는 항목에 대해서는 아예 비워줘야 에러 발생안함
        // 모든 값을 같이 보내면 안된다.
        case .patchUserProfile(let request):
            return request

        case .patchNote(_, let request):
            return request

        default:
            return nil
        }
    }

    public typealias Response = R

    public var baseURL: String? {
        guard let baseURL = Bundle.main.baseServerURL else {
            return nil
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
            
        case .getArtist(let artistID):
            return "/api/v1/artists/\(artistID)"

        case .searchArtists:
            return "/api/v1/artists/search"
            
        case .getIsFavoriteArtist:
            return "/api/v1/favorite-artists/exists"

        case .postFavoriteArtists:
            return "/api/v1/favorite-artists/batch"
            
        case .getFavoriteArtists,
             .postFavoriteArtist,
             .deleteFavoriteArtist:
            return "/api/v1/favorite-artists"

        case .getFavoriteArtistsRelatedNotes:
            return "/api/v1/notes"
            
        case .getFavoriteArtistsHavingNotes:
            return "/api/v1/favorite-artists/having-notes"

        case .getFavoriteArtistsBookmarked:
            return "/api/v1/favorite-artists/bookmarked"

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
            
        case .getSongDetail(let songID):
            return "/api/v1/songs/\(songID)"
            
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

        case .getPersonalNotifications:
            return "/api/v1/notifications/personal"

        case .getPublicNotifications:
            return "/api/v1/notifications/public"

        case .getHasUncheckedNotification:
            return "/api/v1/notifications/check"
            
        case .checkNotification(let notificationID):
            return "/api/v1/notifications/\(notificationID)"

        case .getUserProfile, .patchUserProfile:
            return "/api/v1/users"

        case .deleteUser:
            return "/api/v1/auth/delete"

        case .checkFirstVisitor:
            return "/api/v1/users/first-time"
            
        case .postBlockUserProfile,
             .deleteBlockUserProfile:
            return "/api/v1/blocks"
            
        case .getBlockedUsers:
            return "/api/v1/users/blocks"
            
        case .getEvents:
            return "/api/v1/events"
            
        case .postEventRefuse:
            return "/api/v1/events/refuse"
            
        case .getBanners:
            return "/api/v1/banners"
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
             .postFavoriteArtist,
             .postBlockUserProfile,
             .postEventRefuse:
            return .post

        case .checkUserValidity, 
             .getArtists,
             .getArtist,
             .searchArtists,
             .getIsFavoriteArtist,
             .getFavoriteArtists,
             .getFavoriteArtistsRelatedNotes,
             .getFavoriteArtistsHavingNotes,
             .getFavoriteArtistsBookmarked,
             .searchSongs,
             .getSearchedNotes,
             .getSongDetail,
             .getSongNotes,
             .getNoteWithComments,
             .getPersonalNotifications,
             .getPublicNotifications,
             .getHasUncheckedNotification,
             .getArtistNotes,
             .getMyNotes,
             .getUserProfile,
             .checkFirstVisitor,
             .getMyNotesByBookmark,
             .getBlockedUsers,
             .getEvents,
             .getBanners:
            return .get
            
        case .deleteLikes, 
             .deleteBookmarks,
             .deleteNote,
             .deleteComment,
             .deleteFavoriteArtist,
             .deleteUser,
             .deleteBlockUserProfile:
            return .delete
            
        case .checkNotification,
             .patchUserProfile,
             .patchNote:
            return .patch
        }
    }
}
