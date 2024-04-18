import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .core(
        interface: .DependencyInjection,
        factory: .init()
    ),
    .core(
        implements: .DependencyInjection,
        factory: .init(
            dependencies: [
                .core(interface: .DependencyInjection)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Core.DependencyInjection.rawValue,
    targets: targets
)
