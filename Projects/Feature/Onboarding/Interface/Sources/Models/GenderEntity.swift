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
    public var description: String {
        switch self {
        case .male:     "남성"
        case .female:   "여성"
        }
    }

    public var activeImage: UIImage {
        switch self {
        case .male:     FeelinImages.maleActive
        case .female:   FeelinImages.femaleActive
        }
    }

    public var inactiveImage: UIImage {
        switch self {
        case .male:     FeelinImages.maleInactive
        case .female:   FeelinImages.femaleInactive
        }
    }

    public var index: Int {
        switch self {
        case .male:
            return 0
        case .female:
            return 1
        }
    }
}
