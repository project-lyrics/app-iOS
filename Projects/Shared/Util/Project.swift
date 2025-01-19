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
                )
            ]
        )
    ),
    .shared(
        tests: .Util,
        factory: .init(dependencies: [
            .shared(implements: .Util)
        ])
    )
]

let project = Project.makeModule(
    name: ModulePath.Shared.Util.rawValue,
    targets: targets
)
