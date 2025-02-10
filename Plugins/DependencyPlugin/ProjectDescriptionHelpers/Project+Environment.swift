//
//  Project+Environment.swift
//  MyPlugin
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription

// 첫 번째 자리1은 메이저 업데이트
// 두 번째 자리1은 기능 리뉴얼과 기능 중규모 업데이트
// 세 번째 자리는 자잘한 디버깅 및 소소한 수정 업데이트

private let currentAppVersion: String = "1.0.1"

public extension Project {
    enum Environment {
        public static let appName = "Feelin"
        public static let deploymentTargets = DeploymentTargets.iOS("15.0")
        public static let bundleId = "com.project.feelin"
        public static let projectSettings: Settings = .settings(
            base: [
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let defaultTargetSettings: Settings = .settings(
            base: [
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
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
                "BUNDLE_LOADER": "$(BUILT_PRODUCTS_DIR)/$(TEST_TARGET_NAME).app/$(TEST_TARGET_NAME)",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let exampleAppDefaultSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev),
                .build(.qa),
                .build(.prod)
            ]
        )
        public static let devTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev)
            ]
        )
        public static let qaTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.dev)
            ]
        )
        public static let prodTargetSettings: Settings = .settings(
            base: [
                "DEVELOPMENT_TEAM": "${DEVELOPMENT_TEAM_ID}",
                "ENABLE_USER_SCRIPT_SANDBOXING": "YES"
            ],
            configurations: [
                .build(.prod)
            ]
        )
        // TODO: 나중에 Firebase analytics, Crashlytics 등의 광고 추척이 필요한 경우 변경해야함 - dk
        public static let privacyManifest: PrivacyManifest = .privacyManifest(
            tracking: false,
            trackingDomains: [],
            collectedDataTypes: [
                [
                    "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeUserID",
                    "NSPrivacyCollectedDataTypeLinked": true,
                    "NSPrivacyCollectedDataTypeTracking": false,
                    "NSPrivacyCollectedDataTypePurposes": [
                        "NSPrivacyCollectedDataTypePurposeAppFunctionality",
                    ],
                ],
                [
                    "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeDeviceID",
                    "NSPrivacyCollectedDataTypeLinked": true,
                    "NSPrivacyCollectedDataTypeTracking": false,
                    "NSPrivacyCollectedDataTypePurposes": [
                        "NSPrivacyCollectedDataTypePurposeAppFunctionality",
                    ],
                ],
                [
                    "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeCustomerSupport",
                    "NSPrivacyCollectedDataTypeLinked": true,
                    "NSPrivacyCollectedDataTypeTracking": false,
                    "NSPrivacyCollectedDataTypePurposes": [
                        "NSPrivacyCollectedDataTypeCustomerSupport",
                    ],
                    "AdditionalInfo": [
                        "PhoneNumber",
                        "Email",
                    ],
                ],
                [
                    "NSPrivacyCollectedDataType": "NSPrivacyCollectedDataTypeOtherUserContent",
                    "NSPrivacyCollectedDataTypeLinked": true,
                    "NSPrivacyCollectedDataTypeTracking": false,
                    "NSPrivacyCollectedDataTypePurposes": [
                        "NSPrivacyCollectedDataTypeOtherUserContent",
                    ],
                ],
            ],
            accessedApiTypes: [
                [
                    "NSPrivacyAccessedAPIType": "NSPrivacyAccessedAPICategoryUserDefaults",
                    "NSPrivacyAccessedAPITypeReasons": [
                        "CA92.1",
                    ],
                ],
            ]
        )

        public static func appInfoPlist(deploymentTarget: ProjectDeploymentTarget) -> InfoPlist {
            var kakaoNativeAppKey: String = ""
            var baseServerURL: String = ""
            var displayName: String = ""
            
            switch deploymentTarget {
            case .dev:
                kakaoNativeAppKey = "${KAKAO_NATIVE_APP_KEY_DEV}"
                baseServerURL = "${BASE_SERVER_URL_DEV}"
                displayName = "\(Environment.appName)-\(deploymentTarget.rawValue)"
            case .qa:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_QA}"
                baseServerURL = "${BASE_SERVER_URL_QA}"
                displayName = "\(Environment.appName)-\(deploymentTarget.rawValue)"
            case .prod:
                kakaoNativeAppKey =  "${KAKAO_NATIVE_APP_KEY_PROD}"
                baseServerURL = "${BASE_SERVER_URL_PROD}"
                displayName = Environment.appName
            }
            
            return .extendingDefault(with: [
                "CFBundleShortVersionString": "\(currentAppVersion)",
                "CFBundleDisplayName": "\(displayName)",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen",
                "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
                "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
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
                    "kakaolink",
                    "youtubemusic",
                    
                ],
                "ACCESS_TOKEN_KEY": "${ACCESS_TOKEN_KEY}",
                "REFRESH_TOKEN_KEY": "${REFRESH_TOKEN_KEY}",
                "USER_INFO_KEY": "${USER_INFO_KEY}",
                "DEVELOPMENT_TEAM_ID": "${DEVELOPMENT_TEAM_ID}",
                "ITSAppUsesNonExemptEncryption": false
            ])
        }
    }
}
