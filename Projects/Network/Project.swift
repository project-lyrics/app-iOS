//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .network(
        factory: .init(
            dependencies: [
                .network(implements: .Onboarding),
                .shared
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Network.name,
    targets: targets
)
