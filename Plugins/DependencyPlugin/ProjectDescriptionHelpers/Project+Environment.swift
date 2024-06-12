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
        public static let projectSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let defaultTargetSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let testsAppDefaultSettings: Settings = .settings(
            base: [
                "TEST_HOST": "",
                "BUNDLE_LOADER": "$(BUILT_PRODUCTS_DIR)/$(TEST_TARGET_NAME).app/$(TEST_TARGET_NAME)"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let exampleAppDefaultSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let devTargetSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ],
            configurations: [
                .build(.dev)
            ]
        )
        public static let qaTargetSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ],
            configurations: [
                .build(.dev)
            ]
        )
        public static let prodTargetSettings: Settings = .settings(
            base: [
                "GCC_PREPROCESSOR_DEFINITIONS": "$(inherited) FLEXLAYOUT_SWIFT_PACKAGE=1"
            ],
            configurations: [
                .build(.prod)
            ]
        )
        public static func appInfoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
            var kakaoNativeAppKey: String = ""
            var baseServerURL: String = ""
            switch deploymentTarget {
            case .dev:
                kakaoNativeAppKey = "${KAKAO_NATIVE_APP_KEY_DEV}"
                baseServerURL = "${BASE_SERVER_URL_DEV}"
            case .qa:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_QA}"
                baseServerURL = "${BASE_SERVER_URL_QA}"
            case .prod:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_PROD}"
                baseServerURL = "${BASE_SERVER_URL_PROD}"
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
                "BASE_SERVER_URL": "\(baseServerURL)",
                "LSApplicationQueriesSchemes": [
                    "kakaokompassauth",
                    "kakaolink"
                ]
            ])
        }
    }
}
