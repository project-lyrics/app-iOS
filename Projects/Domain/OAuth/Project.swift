import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        interface: .OAuth,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(interface: .LocalStorage)
            ]
        )
    ),
    .domain(
        implements: .OAuth,
        factory: .init(
            dependencies: [
                .domain(interface: .OAuth),
                .SPM.KakaoSDKUser
            ]
        )
    ),
    .domain(
        testing: .OAuth,
        factory: .init(
            dependencies: [
                .domain(interface: .OAuth)
            ]
        )
    ),
    .domain(
        tests: .OAuth,
        factory: .init(
            dependencies: [
                .domain(testing: .OAuth),
                .domain(implements: .OAuth)
            ]
        )
    ),
]

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.OAuth.rawValue,
    targets: targets
)
