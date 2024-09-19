//
//  InjectIdentifier.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/18/24.
//

import Core
import Domain

public struct InjectIdentifier<T> {
    private (set) var type: T.Type? = nil
    private (set) var key: String? = nil

    private init(
        type: T.Type? = nil,
        key: String? = nil
    ) {
        self.type = type
        self.key = key
    }

    public static func by(type: T.Type? = nil, key: String? = nil) -> InjectIdentifier {
        return .init(type: type, key: key)
    }
}

public extension InjectIdentifier {
    static var networkProvider: InjectIdentifier<NetworkProviderInterface> {
        .by(type: NetworkProviderInterface.self, key: "networkProvider")
    }

    static var tokenStorage: InjectIdentifier<TokenStorageInterface> {
        .by(type: TokenStorageInterface.self, key: "tokenStorage")
    }
    
    static var userInfoStorage: InjectIdentifier<UserInfoStorageInterface> {
        .by(type: UserInfoStorageInterface.self, key: "userInfoStorage")
    }

    static var recentLoginRecordStorage: InjectIdentifier<RecentLoginRecordStorageInterface> {
        .by(type: RecentLoginRecordStorageInterface.self, key: "recentLoginRecordStorage")
    }
}

public extension InjectIdentifier {
    static var kakaoOAuthService: InjectIdentifier<OAuthServiceInterface & UserVerifiable> {
        .by(type: (OAuthServiceInterface & UserVerifiable).self, key: "kakaoOAuthService")
    }

    static var appleOAuthService: InjectIdentifier<OAuthServiceInterface & UserVerifiable> {
        .by(type: (OAuthServiceInterface & UserVerifiable).self, key: "appleOAuthService")
    }

    static var userValidityService: InjectIdentifier<UserValidityServiceInterface> {
        .by(type: UserValidityServiceInterface.self, key: "userValidityService")
    }

    static var recentLoginRecordService: InjectIdentifier<RecentLoginRecordServiceInterface> {
        .by(type: RecentLoginRecordServiceInterface.self, key: "recentLoginRecordService")
    }

    static var signUpService: InjectIdentifier<SignUpServiceInterface> {
        .by(type: SignUpServiceInterface.self, key: "signUpService")
    }
    
    static var artistAPIService:
    InjectIdentifier<ArtistAPIServiceInterface> {
        .by(type: ArtistAPIServiceInterface.self, key: "artistAPIService")
    }
    
    static var artistPaginationService: InjectIdentifier<KeywordPaginationServiceInterface> {
        .by(type: KeywordPaginationServiceInterface.self, key: "artistPaginationService")
    }
    
    static var searchedNotePaginationService: InjectIdentifier<KeywordPaginationServiceInterface> {
        .by(type: KeywordPaginationServiceInterface.self, key: "searchedNotePaginationService")
    }

    static var noteAPIService: InjectIdentifier<NoteAPIServiceInterface> {
        .by(type: NoteAPIServiceInterface.self, key: "noteAPIService")
    }
    
    static var commentAPIService: InjectIdentifier<CommentAPIServiceInterface> {
        .by(type: CommentAPIServiceInterface.self, key: "commentAPIService")
    }
    
    static var notePaginationService: InjectIdentifier<NotePaginationServiceInterface> {
        .by(type: NotePaginationServiceInterface.self, key: "notePaginationService")
    }
    
    static var songPaginationService: InjectIdentifier<SongPaginationServiceInterface> {
        .by(type: SongPaginationServiceInterface.self, key: "SongPaginationService")
    }
}

extension InjectIdentifier: Hashable {
    public static func == (lhs: InjectIdentifier<T>, rhs: InjectIdentifier<T>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)

        if let type = self.type {
            hasher.combine(ObjectIdentifier(type))
        }
    }
}
