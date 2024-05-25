//
//  Project+Environment.swift
//  MyPlugin
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription

public extension Project {
    enum Environment {
        public static let appName = "Feelin"
        public static let deploymentTargets = DeploymentTargets.iOS("15.0")
        public static let bundleId = "com.project.feelin"
        public static let appDefaultSettings: Settings = .settings(
            base: ["GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"],
            configurations: [
                .debug(
                    name: "Debug",
                    settings: ["SWIFT_ACTIVE_COMPILATION_CONDITIONS": "$(inherited) MOCKING"],
                    xcconfig: nil
                ),
                .release(
                    name: "Release",
                    settings: [:],
                    xcconfig: nil
                ),
            ]
        )
        public static let defaultSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1",
                "OTHER_LDFLAGS": "$(inherited) -all_load"
            ]
        )
        public static let testsAppDefaultSettings: Settings = .settings(
            base: [
                "TEST_HOST": "",
                "BUNDLE_LOADER": "$(BUILT_PRODUCTS_DIR)/$(TEST_TARGET_NAME).app/$(TEST_TARGET_NAME)"
            ]
        )
        public static let exampleAppDefaultSettings: Settings = .settings(
            base: [
                "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load",
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ]
        )
    }
}
