//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 4/23/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        factory: .init(
            dependencies: [
                .core,
                .domain(implements: .OAuth),
                .domain(implements: .Artist),
                .domain(implements: .Note),
                .domain(implements: .Report),
                .domain(implements: .Notification),
                .domain(implements: .Shared)
            ]
        )
    ),
    .target(
        name: "\(ModulePath.Domain.name)Tests",
        destinations: .iOS,
        product: .unitTests,
        bundleId: Project.Environment.bundleId + ".Tests",
        deploymentTargets: Project.Environment.deploymentTargets,
        sources: .tests,
        dependencies: [
            .core(testing: .Network),
            .core,
            .domain
        ],
        settings: Project.Environment.devTargetSettings
    )
]

let project: Project = .makeModule(
    name: "Domain",
    targets: targets
)
