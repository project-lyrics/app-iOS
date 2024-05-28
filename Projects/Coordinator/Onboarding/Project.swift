import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name + ModulePath.Coordinator.Onboarding.rawValue,
    packages: [
        .remote(url: "https://github.com/layoutBox/FlexLayout", requirement: .upToNextMajor(from: "2.0.7"))
    ],
    targets: [
        .coordinator(
            interface: .Onboarding,
            factory: .init(
                dependencies: [
                    .feature,
                    .coordinator(interface: .App),
                    .SPM.FlexLayout
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
