//
//  Path+xcconfig.swift
//  DependencyPlugin
//
//  Created by 황인우 on 5/21/24.
//

import ProjectDescription

extension Path {
    public static func relativeToXCConfig(target: ProjectDeploymentTarget) -> Self {
        return .relativeToRoot("./Projects/App/xcconfigs/\(target.rawValue).xcconfig")
    }
}
