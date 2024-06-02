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
        interface: .Onboarding,
        factory: .init(
            dependencies: [
                .dependencyInjection,
                .SPM.FlexLayout
            ]
        )
    ),
    .feature(
        implements: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    ),
    .feature(
        testing: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    ),
    .feature(
        tests: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(testing: .Onboarding)
            ]
        )
    ),
    .feature(
        example: .Onboarding,
        factory: .init(
            dependencies: [
                .feature(interface: .Onboarding)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Onboarding.rawValue,
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: targets
)
