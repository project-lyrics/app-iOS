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
    .service(
        factory: .init(
            dependencies: [
                .service(implements: .User),
                .network
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Service",
    targets: targets
)
