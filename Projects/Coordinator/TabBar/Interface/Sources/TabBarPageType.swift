//
//  TabBarPageType.swift
//  CoordinatorTabBarInterface
//
//  Created by Derrick kim on 5/8/24.
//

import UIKit

// TODO: 추후 변경 예정
enum TabBarPageType: CaseIterable {
    case main

    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(
                title: self.title,
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        }
    }

    var index: Int {
        switch self {
        case .main:        return 0
        }
    }

    private var title: String {
        switch self {
        case .main:        return "홈"
        }
    }
}
