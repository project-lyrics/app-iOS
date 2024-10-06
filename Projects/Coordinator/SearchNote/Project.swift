import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name+ModulePath.Coordinator.SearchNote.rawValue,
    targets: [
        .coordinator(
            interface: .SearchNote,
            factory: .init(
                dependencies: [
                    .feature,
                    .coordinator(interface: .App)
                ]
            )
        ),
        .coordinator(
            implements: .SearchNote,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .SearchNote)
                ]
            )
        ),

        .coordinator(
            testing: .SearchNote,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .SearchNote)
                ]
            )
        ),
        .coordinator(
            tests: .SearchNote,
            factory: .init(
                dependencies: [
                    .coordinator(testing: .SearchNote)
                ]
            )
        ),

    ]
)
