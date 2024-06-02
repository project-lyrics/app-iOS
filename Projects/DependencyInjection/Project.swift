import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let target: Target = .dependencyInjection(
    factory: .init(
        dependencies: [
            .domain
        ]
    )
)

let project = Project.makeModule(
    name: ModulePath.DependencyInjection.name,
    targets: [target]
)
