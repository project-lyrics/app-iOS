import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Coordinator.name+ModulePath.Coordinator.MyPage.rawValue,
    targets: [
        .coordinator(
            interface: .MyPage,
            factory: .init(
                dependencies: [
                    .feature,
                    .coordinator(interface: .App)
                ]
            )
        ),
        .coordinator(
            implements: .MyPage,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .MyPage)
                ]
            )
        ),

        .coordinator(
            testing: .MyPage,
            factory: .init(
                dependencies: [
                    .coordinator(interface: .MyPage)
                ]
            )
        ),
        .coordinator(
            tests: .MyPage,
            factory: .init(
                dependencies: [
                    .coordinator(testing: .MyPage)
                ]
            )
        ),

    ]
)
