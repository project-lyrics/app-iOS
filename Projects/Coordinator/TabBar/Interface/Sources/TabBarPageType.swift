//
//  TabBarPageType.swift
//  CoordinatorTabBarInterface
//
//  Created by Derrick kim on 5/8/24.
//

import UIKit

// TODO: 추후 변경 예정
enum TabBarPageType: Int, CaseIterable {
    case main = 0

    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        }
    }
}
