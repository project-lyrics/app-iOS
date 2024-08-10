//
//  TargetFactory.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription
import DependencyPlugin

// MARK: Target + Template

public struct TargetFactory {
    var name: String
    var destinations: Destinations
    var product: Product
    var productName: String?
    var bundleId: String?
    var deploymentTargets: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var copyFiles: [CopyFilesAction]?
    var headers: Headers?
    var entitlements: Entitlements?
    var scripts: [TargetScript]
    var dependencies: [TargetDependency]
    var settings: Settings
    var coreDataModels: [CoreDataModel]
    var environmentVariables: [String : EnvironmentVariable]
    var launchArguments: [LaunchArgument]
    var additionalFiles: [FileElement]
    var buildRules: [BuildRule]
    var mergedBinaryType: MergedBinaryType
    var mergeable: Bool

    public init(
        name: String = "",
        destinations: Destinations = [.iPhone],
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String? = nil,
        deploymentTargets: DeploymentTargets? = Project.Environment.deploymentTargets,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = nil,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings = Project.Environment.defaultTargetSettings,
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String : EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = [],
        buildRules: [BuildRule] = [],
        mergedBinaryType: MergedBinaryType = .disabled,
        mergeable: Bool = false
    ) {
        self.name = name
        self.destinations = destinations
        self.product = product
        self.productName = productName
        self.bundleId = bundleId
        self.deploymentTargets = deploymentTargets
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.environmentVariables = environmentVariables
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
        self.buildRules = buildRules
        self.mergedBinaryType = mergedBinaryType
        self.mergeable = mergeable
    }
}

public extension Target {
    private static func make(factory: TargetFactory) -> Self {
        return .target(
            name: factory.name,
            destinations: factory.destinations,
            product: factory.product,
            productName: factory.productName,
            bundleId: factory.bundleId ?? "\(Project.Environment.bundleId).\(factory.name)",
            deploymentTargets: factory.deploymentTargets,
            infoPlist: factory.infoPlist,
            sources: factory.sources,
            resources: factory.resources,
            copyFiles: factory.copyFiles,
            headers: factory.headers,
            entitlements: factory.entitlements,
            scripts: factory.scripts,
            dependencies: factory.dependencies,
            settings: factory.settings,
            coreDataModels: factory.coreDataModels,
            environmentVariables: factory.environmentVariables,
            launchArguments: factory.launchArguments,
            additionalFiles: factory.additionalFiles,
            buildRules: factory.buildRules,
            mergedBinaryType: factory.mergedBinaryType,
            mergeable: factory.mergeable
        )
    }
}

public extension Target {
    static func app(
        implements module: ModulePath.App,
        deploymentTarget: ProjectDeploymentTarget,
        factory: TargetFactory
    ) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.App.name + module.rawValue
        switch module {
        case .iOS:
            newFactory.product = .app
            newFactory.name = Project.Environment.appName + "-\(deploymentTarget.rawValue)"
            newFactory.bundleId = Project.Environment.bundleId + "-\(deploymentTarget.rawValue)"
            newFactory.resources = ["Resources/**"]
            newFactory.sources = .sources
            newFactory.productName = Project.Environment.appName
            newFactory.scripts = [.SwiftLintString]
            newFactory.dependencies = factory.dependencies
        }
        
        return make(factory: newFactory)
    }
}

public extension Target {
    static func feature(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func feature(implements module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue
        newFactory.sources = .sources
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func feature(interface module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        newFactory.scripts = [.SwiftLintString]
        newFactory.product = Environment.forPreview.getBoolean(default: false) ? .framework : .staticLibrary

        return make(factory: newFactory)
    }

    static func feature(testing module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }

    static func feature(tests module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Tests"
        newFactory.sources = .tests
        newFactory.product = .unitTests
        newFactory.settings = Project.Environment.devTargetSettings

        return make(factory: newFactory)
    }

    static func feature(example module: ModulePath.Feature, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Feature.name + module.rawValue + "Example"
        newFactory.bundleId = Project.Environment.bundleId + "-\(module.rawValue)"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        newFactory.settings = Project.Environment.exampleAppDefaultSettings

        return make(factory: newFactory)
    }
}

public extension Target {
    static func coordinator(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Coordinator.name
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func coordinator(implements module: ModulePath.Coordinator, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Coordinator.name + module.rawValue
        newFactory.sources = .sources
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func coordinator(interface module: ModulePath.Coordinator, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Coordinator.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func coordinator(testing module: ModulePath.Coordinator, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Coordinator.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }

    static func coordinator(tests module: ModulePath.Coordinator, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Coordinator.name + module.rawValue + "Tests"
        newFactory.sources = .tests
        newFactory.product = .unitTests
        newFactory.settings = Project.Environment.devTargetSettings

        return make(factory: newFactory)
    }
}

public extension Target {
    static func dependencyInjection(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.DependencyInjection.name
        newFactory.sources = .sources
        
        return make(factory: newFactory)
    }
}

public extension Target {
    static func domain(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func domain(implements module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue
        newFactory.sources = .sources
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func domain(interface module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func domain(testing module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }

    static func domain(tests module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Tests"
        newFactory.sources = .tests
        newFactory.product = .unitTests
        newFactory.settings = Project.Environment.devTargetSettings

        return make(factory: newFactory)
    }
}

public extension Target {
    static func core(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func core(implements module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue
        newFactory.sources = .sources
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func core(interface module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        newFactory.scripts = [.SwiftLintString]

        return make(factory: newFactory)
    }

    static func core(testing module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Testing"
        newFactory.sources = .testing

        return make(factory: newFactory)
    }

    static func core(tests module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Tests"
        newFactory.sources = .tests
        newFactory.product = .unitTests
        newFactory.settings = Project.Environment.devTargetSettings

        return make(factory: newFactory)
    }

    static func core(example module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name + module.rawValue + "Example"
        newFactory.sources = .exampleSources
        newFactory.product = .app
        newFactory.settings = Project.Environment.exampleAppDefaultSettings
        newFactory.scripts = [.SwiftLintString]
        newFactory.bundleId = Project.Environment.bundleId + "-\(module.rawValue)"

        return make(factory: newFactory)
    }
}

public extension Target {
    static func shared(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name
        newFactory.sources = .sources

        return make(factory: newFactory)
    }

    static func shared(implements module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name + module.rawValue
        newFactory.sources = .sources
        newFactory.scripts = [.SwiftLintString]

        if module == .DesignSystem {
            newFactory.product = .staticFramework
            newFactory.resources = ["Resources/**"]
        }

        return make(factory: newFactory)
    }
}
