//
//  InjectIdentifier.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/18/24.
//

import CoreNetworkInterface
import CoreLocalStorageInterface
import DomainOAuthInterface

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
