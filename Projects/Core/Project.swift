//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 황인우 on 3/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
	.core(
		factory: .init(
			dependencies: [
                .shared,
                .core(implements: .Network),
				.core(implements: .DependencyInjection),
				.core(implements: .LocalStorage)
			]
		)
	)
]

let project: Project = .makeModule(
	name: "Core",
	targets: targets
)
