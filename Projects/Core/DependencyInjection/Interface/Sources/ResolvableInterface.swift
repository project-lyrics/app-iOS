//
//  ResolvableInterface.swift
//  CoreDependencyInjectionInterface
//
//  Created by Derrick kim on 4/18/24.
//

import Foundation

public protocol Resolvable {
    func resolve<Value>(_ identifier: InjectIdentifier<Value>) throws -> Value
}
