//
//  Project.swift
//  Manifests
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .network(
        interface: .Onboarding,
        factory: .init(
            dependencies: [
                .shared
            ]
        )
    ),
    .network(
        implements: .Onboarding,
        factory: .init(
            dependencies: [
                .network(interface: .Onboarding),
            ]
        )
    ),
    .network(
        testing: .Onboarding,
        factory: .init(
            dependencies: [
                .network(interface: .Onboarding),
            ]
        )
    ),
    .network(
        tests: .Onboarding,
        factory: .init(
            dependencies: [
                .network(testing: .Onboarding),
            ]
        )
    ),
]

let project = Project.makeModule(
    name: ModulePath.Network.name + ModulePath.Network.Onboarding.rawValue,
    targets: targets
)
