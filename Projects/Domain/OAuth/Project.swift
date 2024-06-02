import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        interface: .OAuth,
        factory: .init(
            dependencies: [
                .core
            ]
        )
    ),
    .domain(
        implements: .OAuth,
        factory: .init(
            dependencies: [
                .domain(interface: .OAuth)
            ]
        )
    ),
    .domain(
        testing: .OAuth,
        factory: .init(
            dependencies: [
                .domain(interface: .OAuth),
                .core
            ]
        )
    ),
    .domain(
        tests: .OAuth,
        factory: .init(
            dependencies: [
                .domain(testing: .OAuth),
                .domain(implements: .OAuth),
                .domain(interface: .OAuth)
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.OAuth.rawValue,
    targets: targets
)
