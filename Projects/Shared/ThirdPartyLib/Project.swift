//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin

let targets: [Target] = [
    .shared(
        implements: .ThirdPartyLib,
        factory: .init(
            infoPlist: .extendingDefault(
                with: [
                    "UIMainStoryboardFile": "",
                    "UILaunchStoryboardName": "",
                    "LSSupportsOpeningDocumentsInPlace": true
                ]
            ),
            dependencies: [
                .SPM.Kingfisher,
                .SPM.PinLayout,
                .SPM.KakaoSDKAuth,
                .SPM.KakaoSDKUser,
                .SPM.KakaoSDKCommon,
                .Carthage.FlexLayout
            ]
        )
    )
]

let project: Project = .makeModule(
    name: ModulePath.Shared.ThirdPartyLib.rawValue,
	packages: [
		.remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
		.remote(url: "https://github.com/layoutBox/PinLayout", requirement: .upToNextMajor(from: "1.10.5")),
		.remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMajor(from: "2.22.1"))
	],
    targets: targets
)
