import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        interface: .Home,
        factory: .init(
            dependencies: [
                .dependencyInjection,
                .shared,
                .domain
            ]
        )
    ),
    .feature(
        implements: .Home,
        factory: .init(
            dependencies: [
                .feature(interface: .Home)
            ]
        )
    ),
    .feature(
        testing: .Home,
        factory: .init(
            dependencies: [
                .feature(interface: .Home)
            ]
        )
    ),
    .feature(
        tests: .Home,
        factory: .init(
            dependencies: [
                .feature(testing: .Home)
            ]
        )
    ),
    .feature(
        example: .Home,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .dev),
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Home),
                .feature(interface: .Home),
                .feature(testing: .Home),
                .dependencyInjection
            ],
            settings: Project.Environment.exampleAppDefaultSettings
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Home.rawValue,
    targets: targets,
    additionalFiles: [
        .folderReference(path: .relativeToRoot("./Projects/App/xcconfigs"))
    ]
)
