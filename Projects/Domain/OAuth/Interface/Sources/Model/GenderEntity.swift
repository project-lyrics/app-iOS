//
//  GenderEntity.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/7/24.
//

import Foundation
import Core

public enum GenderEntity: CaseIterable {
    case male
    case female

    public var toDTO: Gender {
        switch self {
        case .male:
            return .male
        case .female:
            return .female
        }
    }
}
