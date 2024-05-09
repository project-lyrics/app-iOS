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
        interface: .PostTextUseCase,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(implements: .DependencyInjection),
                .shared(implements: .Util)
            ]
        )
    ),
    .domain(
        implements: .PostTextUseCase,
        factory: .init(
            dependencies: [
                .domain(interface: .PostTextUseCase)
            ]
        )
    ),
    .domain(
        testing: .PostTextUseCase,
        factory: .init(
            dependencies: [
                .domain(interface: .PostTextUseCase)
            ]
        )
    ),
    .domain(
        tests: .PostTextUseCase,
        factory: .init(
            dependencies: [
                .domain(testing: .PostTextUseCase)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.PostTextUseCase.rawValue,
    targets: targets
)

