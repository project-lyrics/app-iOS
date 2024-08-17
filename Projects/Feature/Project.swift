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
    .feature(
        factory: .init(
            dependencies: [
                .feature(implements: .Onboarding),
                .feature(implements: .Main),
                .dependencyInjection
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: targets
)
