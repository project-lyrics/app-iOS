//
//  GenderEntity.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit
import SharedDesignSystem
import Domain

extension GenderEntity {
    var description: String {
        switch self {
        case .male:     "남성"
        case .female:   "여성"
        }
    }

    var activeImage: UIImage {
        switch self {
        case .male:     FeelinImages.maleActive
        case .female:   FeelinImages.femaleActive
        }
    }

    var inactiveImage: UIImage {
        switch self {
        case .male:     FeelinImages.maleInactive
        case .female:   FeelinImages.femaleInactive
        }
    }
}
