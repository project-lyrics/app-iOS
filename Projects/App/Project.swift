//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let appTargets: [Target] = [
    .app(
        implements: .iOS,
        factory: .init(
            infoPlist: Project.Environment.infoPlist(deploymentTarget: .dev),
            entitlements: "Feelin.entitlements",
            dependencies: [
                .coordinator,
                .shared
            ], 
            settings: Project.Environment.devSetting
        )
    ),
    .app(
        implements: .iOS,
        deploymentTarget: .qa,
        factory: .init(
            infoPlist: Project.Environment.infoPlist(deploymentTarget: .qa),
            entitlements: "Feelin.entitlements",
            dependencies: [
                .coordinator,
            ],
            settings: Project.Environment.qaSetting
        )
    ),
    .app(
        implements: .iOS,
        deploymentTarget: .prod,
        factory: .init(
            infoPlist: Project.Environment.infoPlist(deploymentTarget: .prod),
            entitlements: "Feelin.entitlements",
            dependencies: [
                .coordinator,
            ],
            settings: Project.Environment.prodSetting
        )
    )
]

let appProject: Project = .makeModule(
    name: Project.Environment.appName,
    settings: Project.Environment.projectSettings,
    targets: appTargets,
    schemes: appSchemes,
    additionalFiles: [
        "./xcconfigs/Shared.xcconfig",
        "./xcconfigs/KakaoSecretKeys.xcconfig"
    ]
)
