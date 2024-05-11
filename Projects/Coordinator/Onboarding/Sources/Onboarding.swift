//
//  DomainRoot.swift
//  Domain
//
//  Created by Derrick kim on 4/23/24.
//

import UIKit
import CoordinatorAppInterface
import CoordinatorOnboardingInterface

extension OnboardingCoordinator: CoordinatorDelegate {
    public func didFinish(childCoordinator: Coordinator) {
        self.navigationController.popToRootViewController(animated: false)
        self.finish()
    }
}
