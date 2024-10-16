//
//  XBarSwipableNavigationController.swift
//  SharedUtil
//
//  Created by 황인우 on 10/15/24.
//

import UIKit

public final class XBarSwipableNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }

}

extension XBarSwipableNavigationController: UIGestureRecognizerDelegate {
        public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return viewControllers.count > 1
        }
    }
