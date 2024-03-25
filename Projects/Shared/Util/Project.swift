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
    .shared(
        interface: .Util,
        factory: .init()
    ),
    .shared(
        implements: .Util,
        factory: .init(
            dependencies: [
                .shared(interface: .Util)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Shared.Util.rawValue,
    targets: targets
)
