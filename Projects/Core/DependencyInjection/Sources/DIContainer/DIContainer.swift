//
//  DIContainer.swift
//  CoreDependencyInjection
//
//  Created by Derrick kim on 4/17/24.
//

import Foundation
import CoreDependencyInjectionInterface

public final class DIContainer: Injectable {
    public var dependencies: [AnyHashable : Any] = [:]
    public static let standard = DIContainer()
    public required init() { }
}
