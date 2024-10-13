//
//  GenderEntity.swift
//  DomainOAuthInterface
//
//  Created by Derrick kim on 7/7/24.
//

import Foundation
import Core

public enum GenderEntity: String, CaseIterable {
    case male = "MALE"
    case female = "FEMALE"

    public var toDTO: Gender {
        switch self {
        case .male:
            return .male
        case .female:
            return .female
        }
    }
}
