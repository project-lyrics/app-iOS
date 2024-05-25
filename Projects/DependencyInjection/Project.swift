import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let target: Target = .dependencyInjection(
    factory: .init(
        dependencies: [
        ]
    )
)

let project = Project.makeModule(
    name: ModulePath.DependencyInjection.name,
    targets: [target]
)
