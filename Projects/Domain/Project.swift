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
                .core,
                .domain(implements: .OAuth)
            ]
        )
    ),
    .target(
        name: "\(ModulePath.Domain.name)Tests",
        destinations: .iOS,
        product: .unitTests,
        bundleId: Project.Environment.bundleId + ".Tests",
        deploymentTargets: Project.Environment.deploymentTargets,
        sources: .tests,
        dependencies: [
            .domain,
            .core(testing: .Network),
            .SPM.KakaoSDKAuth,
            .SPM.KakaoSDKCommon,
            .SPM.KakaoSDKUser
        ],
        settings: Project.Environment.devSetting
    )
]

let project: Project = .makeModule(
    name: "Domain",
    targets: targets
)
