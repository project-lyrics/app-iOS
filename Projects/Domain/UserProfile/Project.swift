import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Domain.name+ModulePath.Domain.UserProfile.rawValue,
    targets: [
        .domain(
            interface: .UserProfile,
            factory: .init(
                dependencies: [
                    .core,
                    .domain(interface: .OAuth)
                ]
            )
        ),
        .domain(
            implements: .UserProfile,
            factory: .init(
                dependencies: [
                    .domain(interface: .UserProfile)
                ]
            )
        ),
        .domain(
            testing: .UserProfile,
            factory: .init(
                dependencies: [
                    .domain(interface: .UserProfile)
                ]
            )
        ),
        .domain(
            tests: .UserProfile,
            factory: .init(
                dependencies: [
                    .domain(testing: .UserProfile)
                ]
            )
        )
    ]
)
