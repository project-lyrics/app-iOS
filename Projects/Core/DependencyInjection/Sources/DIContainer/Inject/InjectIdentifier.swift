//
//  InjectIdentifier.swift
//  Feature
//
//  Created by Derrick kim on 4/17/24.
//

import Foundation
import CoreDependencyInjectionInterface
import CoreNetworkInterface

public extension InjectIdentifier {
    static var networkService: InjectIdentifier<NetworkProviderProtocol> {
        .by(type: NetworkProviderProtocol.self, key: "networkService")
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
