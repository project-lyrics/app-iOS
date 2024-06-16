//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by Derrick kim on 2/16/24.
//

import ProjectDescription

let swiftLintScript: String = """
if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH

if which swiftlint > /dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
"""

public extension TargetScript {
    static let SwiftLintString = TargetScript.pre(
        script: swiftLintScript,
        name: "SwiftLintString",
        basedOnDependencyAnalysis: false
    )
}
