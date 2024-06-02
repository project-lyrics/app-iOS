//
//  SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/17/24.
//

import ProjectDescription

extension TargetDependency {
    public struct SPM {}
}

public extension TargetDependency.SPM {
    static let Kingfisher = Self.package(product: "Kingfisher")
    static let FlexLayout = Self.package(product: "FlexLayout")
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
