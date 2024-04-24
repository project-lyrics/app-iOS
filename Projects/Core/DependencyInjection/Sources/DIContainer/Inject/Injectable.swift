//
//  Injectable.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/17/24.
//

public protocol Injectable: Resolvable, AnyObject {
    init()
    var dependencies: [AnyHashable: Any] { get set }

    func register<Value>(_ identifier: InjectIdentifier<Value>, _ resolve: (Resolvable) throws -> Value)
    func remove<Value>(_ identifier: InjectIdentifier<Value>)
}


public extension Injectable {
    func register<Value>(
        _ identifier: InjectIdentifier<Value>,
        _ resolve: (Resolvable) throws -> Value
    ) {
        do {
            self.dependencies[identifier] = try resolve(self)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func register<Value>(
        type: Value.Type?,
        key: String?,
        _ resolve: (Resolvable) throws -> Value
    ) {
        self.register(.by(type: type, key: key), resolve)
    }

    func remove<Value>(
        _ identifier: InjectIdentifier<Value>
    ) {
        self.dependencies.removeValue(forKey: identifier)
    }

    func remove<Value>(
        type: Value.Type? = nil,
        key: String? = nil
    ) {
        let identifier = InjectIdentifier.by(type: type, key: key)
        self.dependencies.removeValue(forKey: identifier)
    }

    func removeAllDependencies() {
        self.dependencies.removeAll()
    }

    func resolve<Value>(
        _ identifier: InjectIdentifier<Value>
    ) throws -> Value {
        guard let dependency = dependencies[identifier] as? Value else {
            throw ResolveError.dependencyNotFound(identifier.type, identifier.key)
        }
        return dependency
    }

    func resolve<Value>(
        type: Value.Type?,
        key: String?
    ) throws -> Value {
        try self.resolve(.by(type: type, key: key))
    }
}
