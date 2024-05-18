import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: ModulePath.Core.name+ModulePath.Core.LocalStorage.rawValue,
    targets: [
        .core(
            interface: .LocalStorage,
            factory: .init()
        ),
        .core(
            implements: .LocalStorage,
            factory: .init(
                dependencies: [
                    .core(interface: .LocalStorage)
                ]
            )
        ),
		.core(
			example: .LocalStorage,
			factory: .init(
				infoPlist: .extendingDefault(with: [
					"CFBundleShortVersionString": "1.0",
					"CFBundleVersion": "1",
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
					]
				]),
				dependencies: [
					.core(implements: .LocalStorage)
				]
			)
		)
    ]
)
