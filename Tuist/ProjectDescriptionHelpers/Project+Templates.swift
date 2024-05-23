import ProjectDescription
import DependencyPlugin

public extension Project {
    static func makeModule(
        name: String,
        organizationName: String? = nil,
        options: Project.Options = .options(),
        packages: [Package] = [],
        settings: Settings? = Project.Environment.defaultSettings,
        targets: [Target],
        schemes: [Scheme] = [],
        fileHeaderTemplate: FileHeaderTemplate? = nil,
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = []
    ) -> Self {
        return .init(
            name: name,
            organizationName: organizationName,
            options: options,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes,
            fileHeaderTemplate: fileHeaderTemplate,
            additionalFiles: additionalFiles,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}
