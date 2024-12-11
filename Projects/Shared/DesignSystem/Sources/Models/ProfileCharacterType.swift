//
//  ProfileCharacterType.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

public enum ProfileCharacterType: String, CaseIterable {
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

    public var character: String {
        switch self {
        case .shortHair:        return "shortHair"
        case .braidedHair:      return "braidedHair"
        case .partedHair:       return "partedHair"
        case .poopHair:         return "poopHair"
        }
    }

    public var index: Int {
        switch self {
        case .shortHair:
            return 0
        case .braidedHair:
            return 1
        case .partedHair:
            return 2
        case .poopHair:
            return 3
        }
    }

    public static let defaultImage = FeelinImages.profileShortHair
    public static let defaultCharacter = ProfileCharacterType.shortHair.character
}
