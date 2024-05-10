import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        interface: .Main,
        factory: .init()
    ),
    .feature(
        implements: .Main,
        factory: .init(
            dependencies: [
                .feature(interface: .Main)
            ]
        )
    ),
    .feature(
        testing: .Main,
        factory: .init(
            dependencies: [
                .feature(interface: .Main)
            ]
        )
    ),
    .feature(
        tests: .Main,
        factory: .init(
            dependencies: [
                .feature(testing: .Main)
            ]
        )
    ),
    .feature(
        example: .Main,
        factory: .init()
    )
]

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Main.rawValue,
    targets: targets
)
