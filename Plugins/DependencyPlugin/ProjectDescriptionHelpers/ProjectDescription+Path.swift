//
//  ProjectDescription+Path.swift
//  MyPlugin
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription

public extension ProjectDescription.Path {
    static var app: Self {
        return .relativeToRoot("Projects/\(ModulePath.App.name)")
    }
}

public extension ProjectDescription.Path {
    static var feature: Self {
        return .relativeToRoot("Projects/\(ModulePath.Feature.name)")
    }

    static func feature(implementation module: ModulePath.Feature) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Feature.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var service: Self {
        return .relativeToRoot("Projects/\(ModulePath.Service.name)")
    }

    static func service(implementation module: ModulePath.Service) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Service.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var network: Self {
        return .relativeToRoot("Projects/\(ModulePath.Network.name)")
    }

    static func network(implementation module: ModulePath.Network) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Network.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var shared: Self {
        return .relativeToRoot("Projects/\(ModulePath.Shared.name)")
    }

    static func shared(implementation module: ModulePath.Shared) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Shared.name)/\(module.rawValue)")
    }
}
