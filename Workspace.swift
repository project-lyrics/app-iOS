import ProjectDescription
import DependencyPlugin

let workspace = Workspace(
    name: Project.Environment.appName,
    projects: ["Projects/*"]
)
