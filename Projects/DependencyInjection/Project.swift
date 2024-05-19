import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let target: Target = .dependencyInjection(
    factory: .init(
        dependencies: [
            .core
        ]
    )
)

let project = Project.makeModule(
    name: ModulePath.DependencyInjection.name,
    targets: [target]
)
