//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 5/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .coordinator(
        factory: .init(
            dependencies: [
                .coordinator(implements: .App),
                .coordinator(implements: .TabBar),
                .coordinator(implements: .Onboarding),
                .coordinator(implements: .Home),
                .coordinator(implements: .SearchNote),
                .coordinator(implements: .MyPage)
            ]
        )
    )
]

let project: Project = .makeModule(
    name: "Coordinator",
    targets: targets
)
