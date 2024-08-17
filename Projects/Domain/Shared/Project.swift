import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Shared.rawValue,
    targets: [
        .domain(
            interface: .Shared,
            factory: .init()
        ),
        .domain(
            implements: .Shared,
            factory: .init(
                dependencies: [
                    .domain(interface: .Shared)
                ]
            )
        ),
        .domain(
            testing: .Shared,
            factory: .init(
                dependencies: [
                    .domain(interface: .Shared)
                ]
            )
        ),
        .domain(
            tests: .Shared,
            factory: .init(
                dependencies: [
                    .domain(testing: .Shared)
                ]
            )
        ),

    ]
)
