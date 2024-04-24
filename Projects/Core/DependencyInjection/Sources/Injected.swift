//
//  Injected.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/17/24.
//

import Foundation
import CoreDependencyInjectionInterface

@propertyWrapper public struct Injected<Value> {
    public enum InjectError: Error {
        case couldNotResolveAndIsNil
    }

    private let identifier: InjectIdentifier<Value>
    private let container: Resolvable
    private let `default`: Value?

    public lazy var wrappedValue: Value = {
        if let value = try? container.resolve(identifier) {
            return value
        }

        if let `default` {
            return `default`
        }

        fatalError("resolve failed with \(identifier) and default is nil as well.")
    }()

    public init(
        _ identifier: InjectIdentifier<Value>? = nil,
        container: Resolvable? = nil,
        `default`: Value? = nil
    ) {
        self.identifier = identifier ?? .by(type: Value.self)
        self.container = container ?? Self.container()
        self.default = `default`
    }

    public static func container() -> Injectable {
        return DIContainer.standard
    }
}
