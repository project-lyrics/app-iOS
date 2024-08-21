//
//  DomainTestScenario.swift
//  DomainSharedInterface
//
//  Created by 황인우 on 8/19/24.
//

import Foundation

public enum DomainTestScenario<E: LocalizedError> {
    case success
    case failure(E)
}
