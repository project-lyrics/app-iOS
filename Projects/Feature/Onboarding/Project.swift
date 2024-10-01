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
                .dependencyInjection
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
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .qa),
            dependencies: [
                .feature(implements: .Onboarding),
                .feature(interface: .Onboarding),
            ],
            settings: Project.Environment.exampleAppDefaultSettings
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Onboarding.rawValue,
    targets: targets
)
