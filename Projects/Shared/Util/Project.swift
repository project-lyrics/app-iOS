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
        implements: .Util,
        factory: .init(
            dependencies: [
                .sdk(
                    name: "XCTest",
                    type: .framework,
                    status: .optional,
                    condition: nil
                ),
                .SPM.FlexLayout
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Shared.Util.rawValue,
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: targets
)
