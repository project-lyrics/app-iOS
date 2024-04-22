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
                .domain(implements: .PostTextUseCase),
                .core(implements: .DependencyInjection),
                .core(implements: .Network),
                .shared(implements: .Util)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Domain",
    targets: targets
)
