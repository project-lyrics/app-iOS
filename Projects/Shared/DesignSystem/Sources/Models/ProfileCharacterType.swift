//
//  ProfileCharacterType.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

public enum ProfileCharacterType: CaseIterable {
    case profileShortHair
    case profileBraidedHair
    case profile5To5PartedHair
    case profilePoopHair
    
    public var image: UIImage {
        switch self {
        case .profileShortHair:         FeelinImages.profileShortHair
        case .profileBraidedHair:       FeelinImages.profileBraidedHair
        case .profile5To5PartedHair:    FeelinImages.profile5To5PartedHair
        case .profilePoopHair:          FeelinImages.profilePoopHair
        }
    }
    
    public static let defaultImage = FeelinImages.profileShortHair
}
