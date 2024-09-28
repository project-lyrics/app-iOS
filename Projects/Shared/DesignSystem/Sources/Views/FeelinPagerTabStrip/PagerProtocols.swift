//
//  PagerProtocols.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 9/22/24.
//

import UIKit

public protocol IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo
}

public protocol PagerTabStripDelegate: AnyObject {
    func updateIndicator(
        for viewController: FeelinPagerTabViewController,
        fromIndex: Int,
        toIndex: Int
    )
}

public protocol PagerTabStripIsProgressiveDelegate: PagerTabStripDelegate {
    func updateIndicator(
        for viewController: FeelinPagerTabViewController,
        fromIndex: Int,
        toIndex: Int,
        withProgressPercentage progressPercentage: CGFloat,
        indexWasChanged: Bool
    )
}

public protocol PagerTabStripDataSource: AnyObject {
    func viewControllers(
        for pagerTabStripController: FeelinPagerTabViewController
    ) -> [UIViewController]
}
