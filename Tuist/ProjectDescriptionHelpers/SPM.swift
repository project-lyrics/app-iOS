//
//  SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/17/24.
//

import ProjectDescription

extension TargetDependency {
    public struct SPM {}
    public struct Carthage{}
}

public extension TargetDependency.SPM {
    static let Kingfisher = Self.package(product: "Kingfisher")
    static let PinLayout = Self.package(product: "PinLayout")
    static let KakaoSDKCommon = Self.package(product: "KakaoSDKCommon")
    static let KakaoSDKAuth = Self.package(product: "KakaoSDKAuth")
    static let KakaoSDKUser = Self.package(product: "KakaoSDKUser")

    private static func external(_ name: String) -> TargetDependency {
        return TargetDependency.external(name: name)
    }

    private static func package(product: String) -> TargetDependency {
        return TargetDependency.package(product: product)
    }
}

public extension TargetDependency.Carthage {
    static let FlexLayout = Self.xcframework(
        path: .relativeToRoot("Carthage/Build/FlexLayout.xcframework"),
        status: .optional,
        condition: nil
    )
    
    private static func xcframework(
        path: ProjectDescription.Path,
        status: ProjectDescription.FrameworkStatus,
        condition: ProjectDescription.PlatformCondition?
    ) -> TargetDependency {
        return TargetDependency.xcframework(
            path: path,
            status: status,
            condition: condition
        )
    }
}
