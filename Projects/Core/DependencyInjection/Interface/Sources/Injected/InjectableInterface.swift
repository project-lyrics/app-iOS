//
//  InjectableInterface.swift
//  CoreDependencyInjectionInterface
//
//  Created by Derrick kim on 4/18/24.
//

import Foundation

public protocol Injectable: Resolvable, AnyObject {
    init()
    var dependencies: [AnyHashable: Any] { get set }

    func register<Value>(_ identifier: InjectIdentifier<Value>, _ resolve: (Resolvable) throws -> Value)
    func remove<Value>(_ identifier: InjectIdentifier<Value>)
}
