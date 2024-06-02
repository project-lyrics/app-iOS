//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let appSchemes: [Scheme] = [
    .makeScheme(.dev, name: Project.Environment.appName),
    .makeScheme(.qa, name: Project.Environment.appName),
    .makeScheme(.prod, name: Project.Environment.appName)
]

let appTargets: [Target] = [
    .app(
        implements: .iOS,
        deploymentTarget: .dev,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .dev), 
            entitlements: "Feelin.entitlements",
            dependencies: [
                .coordinator,
                .SPM.FlexLayout
            ],
            settings: Project.Environment.devTargetSettings
        )
    ),
    .app(
        implements: .iOS,
        deploymentTarget: .qa,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .qa),
            entitlements: "Feelin.entitlements",
            dependencies: [
                .coordinator,
                .SPM.FlexLayout
            ],
            settings: Project.Environment.qaTargetSettings
        )
    ),
    .app(
        implements: .iOS,
        deploymentTarget: .prod,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .prod),
            entitlements: "Feelin.entitlements",
            dependencies: [
                .coordinator,
                .SPM.FlexLayout
            ],
            settings: Project.Environment.prodTargetSettings
        )
    )
]

let appProject: Project = .makeModule(
    name: Project.Environment.appName,
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: appTargets,
    schemes: appSchemes,
    additionalFiles: [
        "./xcconfigs/Shared.xcconfig",
        "./xcconfigs/KakaoSecretKeys.xcconfig"
    ]
)
