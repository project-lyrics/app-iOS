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
    .service(
        interface: .User,
        factory: .init(
            dependencies: [
                .network
            ]
        )
    ),
    .service(
        implements: .User,
        factory: .init(
            dependencies: [
                .service(interface: .User),
            ]
        )
    ),
    .service(
        testing: .User,
        factory: .init(
            dependencies: [
                .service(interface: .User),
            ]
        )
    ),
    .service(
        tests: .User,
        factory: .init(
            dependencies: [
                .service(testing: .User),
            ]
        )
    ),
]

let project = Project.makeModule(
    name: ModulePath.Service.name + ModulePath.Service.User.rawValue,
    targets: targets
)
