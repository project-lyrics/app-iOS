import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .feature(
        interface: .Main,
        factory: .init(
            dependencies: [
                .dependencyInjection,
                .shared
            ]
        )
    ),
    .feature(
        implements: .Main,
        factory: .init(
            dependencies: [
                .feature(interface: .Main)
            ]
        )
    ),
    .feature(
        testing: .Main,
        factory: .init(
            dependencies: [
                .feature(interface: .Main)
            ]
        )
    ),
    .feature(
        tests: .Main,
        factory: .init(
            dependencies: [
                .feature(testing: .Main)
            ]
        )
    ),
    .feature(
        example: .Main,
        factory: .init(
            infoPlist: Project.Environment.appInfoPlist(deploymentTarget: .dev),
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Main),
                .feature(interface: .Main),
                .feature(testing: .Main),
                .dependencyInjection
            ],
            settings: Project.Environment.exampleAppDefaultSettings
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Feature.name + ModulePath.Feature.Main.rawValue,
    targets: targets,
    additionalFiles: [
        .folderReference(path: .relativeToRoot("./Projects/App/xcconfigs"))
    ]
)
