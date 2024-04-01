//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription
import DependencyPlugin
import ProjectDescriptionHelpers

let appTargets: [Target] = [
    .app(
        implements: .iOS,
        factory: .init(
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen",
                "NSAppTransportSecurity" : ["NSAllowsArbitraryLoads":true],
                "UISupportedInterfaceOrientations" : ["UIInterfaceOrientationPortrait"],
                "UIUserInterfaceStyle":"Light",
                "UIApplicationSceneManifest" : [
                    "UIApplicationSupportsMultipleScenes":true,
                    "UISceneConfigurations":[
                        "UIWindowSceneSessionRoleApplication":[[
                            "UISceneConfigurationName":"Default Configuration",
                            "UISceneDelegateClassName":"$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]]
                    ]
                ]
            ]),
            entitlements: "Feelin.entitlements",
            dependencies: [
                .feature
            ]
        )
    )
]

let appProject: Project = .makeModule(
    name: "Feelin",
    packages: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/layoutBox/PinLayout", .upToNextMajor(from: "1.10.5")),
        .package(url: "https://github.com/layoutBox/FlexLayout", .upToNextMajor(from: "2.0.06"))
    ],
    targets: appTargets
)
