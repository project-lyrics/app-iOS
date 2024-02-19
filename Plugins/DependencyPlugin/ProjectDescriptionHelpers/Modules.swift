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
    case service(Service)
    case network(Network)
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
        case Onboarding

        public static let name: String = "Feature"
    }
}

public extension ModulePath {
    enum Service: String, CaseIterable {
        case User

        public static let name: String = "Service"
    }
}

public extension ModulePath {
    enum Network: String, CaseIterable {
        case Onboarding

        public static let name: String = "Network"
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
