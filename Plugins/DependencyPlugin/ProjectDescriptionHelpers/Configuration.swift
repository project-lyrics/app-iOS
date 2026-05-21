//
//  Configuration.swift
//  DependencyPlugin
//
//  Created by 황인우 on 5/21/24.
//

import ProjectDescription

extension Configuration {
    public static func debugConfiguration(xcconfig: Path? = nil) -> Self {
        return .debug(name: "Debug", xcconfig: xcconfig)
    }

    public static func releaseConfiguration(xcconfig: Path? = nil) -> Self {
        return .release(name: "Release", xcconfig: xcconfig)
    }
}
