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
        factory: .init(
            dependencies: [
                .SPM.FlexLayout
            ]
        )
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
                .coordinator(testing: .App)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.App.rawValue,
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: targets
)
