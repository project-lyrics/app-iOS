import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.Onboarding.rawValue,
    targets: [
        .coordinator(
            interface: .Onboarding,
            factory: .init(
                dependencies: [
                    .feature(interface: .Onboarding)
                ]
            )
        ),
        .coordinator(
            implements: .Onboarding,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .Onboarding)
                ]
            )
        ),
        .coordinator(
            testing: .Onboarding,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .Onboarding)
                ]
            )
        ),
        .coordinator(
            tests: .Onboarding,
            factory: .init(
                dependencies: [
                    .coordinator(testing: .Onboarding)
                ]
            )
        )
    ]
)
