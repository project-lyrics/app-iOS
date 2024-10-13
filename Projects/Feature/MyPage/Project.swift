import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Feature.name+ModulePath.Feature.MyPage.rawValue,
    targets: [
        .feature(
            interface: .MyPage,
            factory: .init(
                dependencies: [
                    .dependencyInjection,
                    .shared,
                    .domain,
                    .feature(interface: .Home),
                    .feature(interface: .Onboarding),
                ]
            )
        ),
        .feature(
            implements: .MyPage,
            factory: .init(
                dependencies: [
                    .feature(interface: .MyPage)
                ]
            )
        ),

        .feature(
            testing: .MyPage,
            factory: .init(
                dependencies: [
                    .feature(interface: .MyPage)
                ]
            )
        ),
        .feature(
            tests: .MyPage,
            factory: .init(
                dependencies: [
                    .feature(testing: .MyPage)
                ]
            )
        ),

        .feature(
            example: .MyPage,
            factory: .init(
                dependencies: [
                    .feature(interface: .MyPage)
                ]
            )
        )

    ]
)
