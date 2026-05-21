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
        factory: .init()
    ),
    .shared(
        testing: .Util,
        factory: .init(
            dependencies: [
                .shared(implements: .Util),
                .sdk(name: "XCTest", type: .framework, status: .optional, condition: nil)
            ]
        )
    ),
    .shared(
        tests: .Util,
        factory: .init(dependencies: [
            .shared(implements: .Util),
            .shared(testing: .Util)
        ])
    )
]

let project = Project.makeModule(
    name: ModulePath.Shared.Util.rawValue,
    targets: targets
)
