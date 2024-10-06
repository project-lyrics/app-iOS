//
//  Modules.swift
//  MyPlugin
//
//  Created by Derrick kim on 2/16/24.
//

import Foundation
import ProjectDescription

public enum ModulePath {
    case feature(Feature)
    case coordinator(Coordinator)
    case dependencyInjection(DependencyInjection)
    case domain(Domain)
    case core(Core)
    case shared(Shared)
}

public extension ModulePath {
    enum App: String, CaseIterable {
        case iOS

        public static let name: String = "App"
    }
}

public extension ModulePath {
    enum Feature: String, CaseIterable {
        case Main
        case Onboarding

        public static let name: String = "Feature"
    }
}

public extension ModulePath {
    enum Coordinator: String, CaseIterable {
        case SearchNote
        case Main
        case TabBar
        case Onboarding
        case App

        public static let name: String = "Coordinator"
    }
}

public extension ModulePath {
    struct DependencyInjection {
        public static let name: String = "DependencyInjection"
    }
}

public extension ModulePath {
    enum Domain: String, CaseIterable {
        case Report
        case Shared
        case Note
        case Artist
        case OAuth
        case Notification

        public static let name: String = "Domain"
    }
}

public extension ModulePath {
    enum Core: String, CaseIterable {
        case LocalStorage
		case Network

        public static let name: String = "Core"
    }
}

public extension ModulePath {
    enum Shared: String, CaseIterable {
        case Util
        case DesignSystem
        case ThirdPartyLib

        public static let name: String = "Shared"
    }
}
