//
//  ProjectDeploymentTarget.swift
//  DependencyPlugin
//
//  Created by 황인우 on 5/17/24.
//

import ProjectDescription

public enum ProjectDeploymentTarget: String {
	case dev = "DEV"
	case qa = "QA"
	case prod = "PROD"
    
    public var configurationName: ConfigurationName {
        return ConfigurationName.configuration(self.rawValue)
    }
}
