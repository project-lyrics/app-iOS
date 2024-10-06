import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.Home.rawValue,
    targets: [
        .coordinator(
            interface: .Home,
            factory: .init(
                dependencies: [
                    .feature,
                    .coordinator(interface: .App)
                ]
            )
        ),
        .coordinator(
            implements: .Home,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .Home)
                ]
            )
        ),
        .coordinator(
            testing: .Home,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .Home)
                ]
            )
        ),
        .coordinator(
            tests: .Home,
            factory: .init(
                dependencies: [
                    .coordinator(testing: .Home)
                ]
            )
        )
    ]
)
