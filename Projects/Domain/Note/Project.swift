import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Note.rawValue,
    targets: [
        .domain(
            interface: .Note,
            factory: .init(
                dependencies: [
                    .core,
                    .domain(interface: .Shared)
                ]
            )
        ),
        .domain(
            implements: .Note,
            factory: .init(
                dependencies: [
                    .domain(interface: .Note)
                ]
            )
        ),
        .domain(
            testing: .Note,
            factory: .init(
                dependencies: [
                    .domain(interface: .Note)
                ]
            )
        ),
        .domain(
            tests: .Note,
            factory: .init(
                dependencies: [
                    .domain(testing: .Note)
                ]
            )
        ),

    ]
)
