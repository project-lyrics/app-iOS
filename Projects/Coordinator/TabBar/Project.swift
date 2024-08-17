import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.TabBar.rawValue,
    targets: [
        .coordinator(
            interface: .TabBar,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .App),
                    .coordinator(interface: .Main),
                ]
            )
        ),
        .coordinator(
            implements: .TabBar,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .TabBar)
                ]
            )
        ),
        .coordinator(
            testing: .TabBar,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .TabBar)
                ]
            )
        ),
        .coordinator(
            tests: .TabBar,
            factory: .init(
                dependencies: [
                    .coordinator(testing: .TabBar)
                ]
            )
        )
    ]
)
