//
//  ProfileCharacterType.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

public enum ProfileCharacterType: CaseIterable {
    case shortHair
    case braidedHair
    case partedHair
    case poopHair
    
    public var image: UIImage {
        switch self {
        case .shortHair:    FeelinImages.profileShortHair
        case .braidedHair:  FeelinImages.profileBraidedHair
        case .partedHair:   FeelinImages.profile5To5PartedHair
        case .poopHair:     FeelinImages.profilePoopHair
        }
    }
    
    public static let defaultImage = FeelinImages.profileShortHair
}
