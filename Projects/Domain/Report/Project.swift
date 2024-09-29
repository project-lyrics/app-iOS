import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.Report.rawValue,
    targets: [
        .domain(
            interface: .Report,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Report,
            factory: .init(
                dependencies: [
                    .domain(interface: .Report)
                ]
            )
        ),

        .domain(
            testing: .Report,
            factory: .init(
                dependencies: [
                    .domain(interface: .Report),
                    .core
                ]
            )
        ),
        .domain(
            tests: .Report,
            factory: .init(
                dependencies: [
                    .domain(testing: .Report)
                ]
            )
        ),

    ]
)
