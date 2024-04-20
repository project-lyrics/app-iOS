//
//  InjectIdentifier.swift
//  CoreDependencyInjectionInterface
//
//  Created by Derrick kim on 4/18/24.
//

public struct InjectIdentifier<T> {
    public private (set) var type: T.Type? = nil
    public private (set) var key: String? = nil

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
