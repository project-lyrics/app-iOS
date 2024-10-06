//
//  TabBarPageType.swift
//  CoordinatorTabBarInterface
//
//  Created by Derrick kim on 5/8/24.
//

import UIKit

// TODO: 추후 변경 예정
enum TabBarPageType: CaseIterable {
    case home
    case noteSearch
    case myPage

    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(
                title: "",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        case .noteSearch:
            return UITabBarItem(
                title: "",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        case .myPage:
            return UITabBarItem(
                title: "",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "house.fill")
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
