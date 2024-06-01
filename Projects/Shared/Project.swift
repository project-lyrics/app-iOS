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
        factory: .init(
            dependencies: [
                .shared(implements: .Util),
                .shared(implements: .DesignSystem)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Shared.name,
    targets: targets
)
