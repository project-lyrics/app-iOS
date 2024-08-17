import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.Main.rawValue,
    targets: [
        .coordinator(
            interface: .Main,
            factory: .init(
                dependencies: [
                    .feature,
                    .coordinator(interface: .App)
                ]
            )
        ),
        .coordinator(
            implements: .Main,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .Main)
                ]
            )
        ),
        .coordinator(
            testing: .Main,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .Main)
                ]
            )
        ),
        .coordinator(
            tests: .Main,
            factory: .init(
                dependencies: [
                    .coordinator(testing: .Main)
                ]
            )
        )
    ]
)
