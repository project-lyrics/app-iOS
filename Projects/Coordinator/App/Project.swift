//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 5/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .coordinator(
        interface: .App,
        factory: .init()
    ),
    .coordinator(
        implements: .App,
        factory: .init(
            dependencies: [
                .coordinator(interface: .App)
            ]
        )
    ),
    .coordinator(
        testing: .App,
        factory: .init(
            dependencies: [
                .coordinator(interface: .App)
            ]
        )
    ),
    .coordinator(
        tests: .App,
        factory: .init(
            dependencies: [
                .coordinator(interface: .App),
                .coordinator(implements: .App),
                .coordinator(testing: .App)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.App.rawValue,
    targets: targets
)
