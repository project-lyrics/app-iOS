//
//  TargetDependency.swift
//  MyPlugin
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription

public extension TargetDependency {
    static var app: Self {
        return .project(target: ModulePath.App.name, path: .app)
    }

    static func app(implements module: ModulePath.App) -> Self {
        return .target(name: ModulePath.App.name + module.rawValue)
    }
}

public extension TargetDependency {
    static var feature: Self {
        return .project(target: ModulePath.Feature.name, path: .feature)
    }

    static func feature(implements module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue, path: .feature(implementation: module))
    }

    static func feature(interface module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Interface", path: .feature(implementation: module))
    }

    static func feature(tests module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Tests", path: .feature(implementation: module))
    }

    static func feature(testing module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Testing", path: .feature(implementation: module))
    }
}

public extension TargetDependency {
    static var service: Self {
        return .project(target: ModulePath.Service.name, path: .service)
    }

    static func service(implements module: ModulePath.Service) -> Self {
        return .project(target: ModulePath.Service.name + module.rawValue, path: .service(implementation: module))
    }

    static func service(interface module: ModulePath.Service) -> Self {
        return .project(target: ModulePath.Service.name + module.rawValue + "Interface", path: .service(implementation: module))
    }

    static func service(tests module: ModulePath.Service) -> Self {
        return .project(target: ModulePath.Service.name + module.rawValue + "Tests", path: .service(implementation: module))
    }

    static func service(testing module: ModulePath.Service) -> Self {
        return .project(target: ModulePath.Service.name + module.rawValue + "Testing", path: .service(implementation: module))
    }
}

public extension TargetDependency {
    static var network: Self {
        return .project(target: ModulePath.Network.name, path: .network)
    }

    static func network(implements module: ModulePath.Network) -> Self {
        return .project(target: ModulePath.Network.name + module.rawValue, path: .network(implementation: module))
    }

    static func network(interface module: ModulePath.Network) -> Self {
        return .project(target: ModulePath.Network.name + module.rawValue + "Interface", path: .network(implementation: module))
    }

    static func network(tests module: ModulePath.Network) -> Self {
        return .project(target: ModulePath.Network.name + module.rawValue + "Tests", path: .network(implementation: module))
    }

    static func network(testing module: ModulePath.Network) -> Self {
        return .project(target: ModulePath.Network.name + module.rawValue + "Testing", path: .network(implementation: module))
    }
}

public extension TargetDependency {
    static var shared: Self {
        return .project(target: ModulePath.Shared.name, path: .shared)
    }

    static func shared(implements module: ModulePath.Shared) -> Self {
        return .project(target: ModulePath.Shared.name + module.rawValue, path: .shared(implementation: module))
    }

    static func shared(interface module: ModulePath.Shared) -> Self {
        return .project(target: ModulePath.Shared.name + module.rawValue + "Interface", path: .shared(implementation: module))
    }
}
