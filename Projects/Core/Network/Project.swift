//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 황인우 on 3/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .core(
        interface: .Network,
        factory: .init(
            dependencies: [
                .shared
            ]
        )
    ),
    .core(
        implements: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network)
            ]
        )
    ),
    .core(
        testing: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network)
            ]
        )
    ),
    .core(
        tests: .Network,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(implements: .Network),
                .core(testing: .Network)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Core.Network.rawValue,
    targets: targets
)
