//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .shared(
        implements: .ThirdPartyLib,
        factory: .init(
            dependencies: [
                .SPM.Kingfisher,
                .SPM.PinLayout,
                .SPM.FlexLayout
            ]
        )
    )
]

let project: Project = .init(
    name: ModulePath.Shared.ThirdPartyLib.rawValue,
    targets: targets
)
