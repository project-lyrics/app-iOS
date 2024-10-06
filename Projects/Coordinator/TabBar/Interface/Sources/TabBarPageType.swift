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
                image: FeelinImages.homeInactiveLight,
                selectedImage: FeelinImages.homeActiveLight
            )
        case .noteSearch:
            return UITabBarItem(
                title: "",
                image: FeelinImages.noteSearchingInactiveLight,
                selectedImage: FeelinImages.noteSearchingActiveLight
            )
        case .myPage:
            return UITabBarItem(
                title: "",
                image: FeelinImages.myPageInactiveLight,
                selectedImage: FeelinImages.myPageActiveLight
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
