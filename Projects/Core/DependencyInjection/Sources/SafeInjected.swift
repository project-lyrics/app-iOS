//
//  SafeInjected.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/17/24.
//

@propertyWrapper public struct SafeInjected<Value> {
    private let identifier: InjectIdentifier<Value>
    private let container: Resolvable
    public lazy var wrappedValue: Value? = try? container.resolve(identifier)

    public init(
        _ identifier: InjectIdentifier<Value>?,
        container: Resolvable?
    ) {
        self.identifier = identifier ?? .by(type: Value.self)
        self.container = container ?? Self.container()
    }

    public static func container() -> Injectable {
        return DIContainer.standard
    }
}
