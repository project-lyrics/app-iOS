//
//  TabBarPageType.swift
//  CoordinatorTabBarInterface
//
//  Created by Derrick kim on 5/8/24.
//

import UIKit

import SharedDesignSystem

enum TabBarPageType: CaseIterable {
    case home
    case noteSearch
    case myPage

    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(
                title: "",
                image: FeelinImages.homeInactive,
                selectedImage: FeelinImages.homeActive
            )
        case .noteSearch:
            return UITabBarItem(
                title: "",
                image: FeelinImages.noteSearchingInactive,
                selectedImage: FeelinImages.noteSearchingActive
            )
        case .myPage:
            return UITabBarItem(
                title: "",
                image: FeelinImages.myPageInactive,
                selectedImage: FeelinImages.myPageActive
            )
        }
    }

    var index: Int {
        switch self {
        case .home:              return 0
        case .noteSearch:        return 1
        case .myPage:            return 2
        }
    }
}
