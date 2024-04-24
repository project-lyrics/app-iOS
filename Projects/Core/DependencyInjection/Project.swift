import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .core(
        implements: .DependencyInjection,
        factory: .init()
    )
]

let project = Project.makeModule(
    name: ModulePath.Core.DependencyInjection.rawValue,
    targets: targets
)
