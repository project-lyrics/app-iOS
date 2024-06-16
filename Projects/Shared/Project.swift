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
                .shared(implements: .DesignSystem),
                .SPM.FlexLayout
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Shared.name,
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: targets
)
