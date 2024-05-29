//
//  Configuration.swift
//  DependencyPlugin
//
//  Created by 황인우 on 5/21/24.
//

import ProjectDescription

extension Configuration {
    public static func build(
        _ type: ProjectDeploymentTarget
    ) -> Self {
        switch type {
        case .dev:
            return .debug(
                name: type.configurationName,
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "$(inherited) MOCKING",
                    "ENABLE_TESTABILITY": true
                ],
                xcconfig: .relativeToXCConfig(target: .dev)
            )
        case .qa:
            return .debug(
                name: type.configurationName,
                settings: [
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "$(inherited) MOCKING",
                    "ENABLE_TESTABILITY": true
                ],
                xcconfig: .relativeToXCConfig(target: .qa)
            )
        case .prod:
            return .release(
                name: type.configurationName,
                settings: [
                    "ENABLE_TESTABILITY": true
                ],
                xcconfig: .relativeToXCConfig(target: .prod)
            )
        }
    }
}
