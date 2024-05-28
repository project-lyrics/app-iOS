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
                .domain,
                .SPM.FlexLayout
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Feature",
    targets: targets
)
