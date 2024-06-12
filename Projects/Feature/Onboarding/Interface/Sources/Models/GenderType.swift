//
//  GenderType.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import Foundation

enum GenderType: CaseIterable {
    case male
    case female
    
    var description: String {
        switch self {
        case .male:     "남성"
        case .female:   "여성"
        }
    }
}
