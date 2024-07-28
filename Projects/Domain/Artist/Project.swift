import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Artist.rawValue,
    targets: [
        .domain(
            interface: .Artist,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Artist,
            factory: .init(
                dependencies: [
                    .domain(interface: .Artist)
                ]
            )
        ),

        .domain(
            testing: .Artist,
            factory: .init(
                dependencies: [
                    .domain(interface: .Artist)
                ]
            )
        ),
        .domain(
            tests: .Artist,
            factory: .init(
                dependencies: [
                    .domain(testing: .Artist)
                ]
            )
        ),

    ]
)
