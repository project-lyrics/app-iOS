//
//  NoteNotificationPageViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/29/24.
//

import Shared

import UIKit

public final class NoteNotificationPageViewController: ButtonBarPagerTabStripViewController {

    override public func viewDidLoad() {
        settings.style.defaultBarBackgroundColor = Colors.gray01
        settings.style.buttonBarBackgroundColor = Colors.background
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = Colors.primary
        settings.style.buttonBarItemFont = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        
        super.viewDidLoad()
    }
    
    override public func viewControllers(for pagerTabStripController: FeelinPagerTabViewController) -> [UIViewController] {
        
        return [
            NoteNotificationViewController(
                indicatorType: .myNotification,
                viewModel: .init()
            ),
            
            NoteNotificationViewController(
                indicatorType: .allNotification,
                viewModel: .init()
            )
        ]
    }
}
