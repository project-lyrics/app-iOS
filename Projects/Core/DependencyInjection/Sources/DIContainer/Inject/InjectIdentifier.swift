//
//  InjectIdentifier.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/18/24.
//

import CoreNetworkInterface

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
    static var networkService: InjectIdentifier<NetworkProviderProtocol> {
        .by(type: NetworkProviderProtocol.self, key: "networkProvider")
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
