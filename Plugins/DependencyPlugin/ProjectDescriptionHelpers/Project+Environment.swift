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
        
        public static func infoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
            var kakaoNativeAppKey: String = ""
            switch deploymentTarget {
            case .dev:
                kakaoNativeAppKey = "${KAKAO_NATIVE_APP_KEY_DEV}"
            case .qa:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_QA}"
            case .prod:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_PROD}"
            }
            
            return .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen",
                "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
                "UIUserInterfaceStyle": "Light",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": true,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [[
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]]
                    ]
                ],
                "CFBundleURLTypes": [
                    [
                        "CFBundleURLName": "",
                        "CFBundleURLSchemes": ["kakao\(kakaoNativeAppKey)"]
                    ]
                ],
                "KAKAO_NATIVE_APP_KEY": "\(kakaoNativeAppKey)",
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth",
                    "kakaolink"
                ]
            ])
        }
    }
}
