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
        factory: .init(
            dependencies: [
                .coordinator(implements: .App),
                .coordinator(implements: .TabBar),
                .coordinator(implements: .Onboarding),
                .coordinator(implements: .Main),
                .SPM.FlexLayout
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Coordinator",
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: targets
)
