import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
    .domain(
        interface: .OAuth,
        factory: .init(
            dependencies: [
                .core(interface: .Network),
                .core(interface: .LocalStorage),
                .SPM.KakaoSDKCommon,
                .SPM.KakaoSDKAuth,
                .SPM.KakaoSDKUser,
            ]
        )
    ),
    .domain(
        implements: .OAuth,
        factory: .init(
            dependencies: [
                .domain(interface: .OAuth),
                .SPM.KakaoSDKCommon,
                .SPM.KakaoSDKAuth,
                .SPM.KakaoSDKUser,
            ]
        )
    ),
    .domain(
        testing: .OAuth,
        factory: .init(
            dependencies: [
                .domain(interface: .OAuth),
                .SPM.KakaoSDKCommon,
                .SPM.KakaoSDKAuth,
                .SPM.KakaoSDKUser,
            ]
        )
    ),
    .domain(
        tests: .OAuth,
        factory: .init(
            dependencies: [
                .domain(testing: .OAuth),
                .domain(implements: .OAuth),
                .domain(interface: .OAuth),
                .SPM.KakaoSDKCommon,
                .SPM.KakaoSDKAuth,
                .SPM.KakaoSDKUser,
            ]
        )
    )
]

let project = Project.makeModule(
    name: ModulePath.Domain.name + ModulePath.Domain.OAuth.rawValue,
    targets: targets
)
