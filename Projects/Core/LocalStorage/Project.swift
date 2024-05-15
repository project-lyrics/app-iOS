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

    ]
)
