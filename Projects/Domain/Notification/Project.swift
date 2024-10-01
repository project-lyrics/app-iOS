//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        interface: .Notification,
        factory: .init(
            dependencies: [
                .core,
                .domain(interface: .Shared)
            ]
        )
    ),
    .domain(
        implements: .Notification,
        factory: .init(
            dependencies: [
                .domain(interface: .Notification)
            ]
        )
    ),
    .domain(
        testing: .Notification,
        factory: .init(
            dependencies: [
                .domain(interface: .Notification)
            ]
        )
    ),
    .domain(
        tests: .Notification,
        factory: .init(
            dependencies: [
                .domain(testing: .Notification)
            ]
        )
    ),
]

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Notification.rawValue,
    targets: targets
)
