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
        implements: .DesignSystem,
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
    name: ModulePath.Shared.DesignSystem.rawValue,
    targets: targets,
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)
