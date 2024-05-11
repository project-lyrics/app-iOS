//
//  AppCoordinator.swift
//  Feelin
//
//  Created by Derrick kim on 4/23/24.
//

import UIKit
import CoordinatorAppInterface
import CoordinatorOnboardingInterface

public final class AppCoordinator: Coordinator {
    public var delegate: CoordinatorDelegate?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator]

    public init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
        self.childCoordinators = []
    }
}

public extension AppCoordinator {
    func start() {
        connectOnboardingCoordinator()
    }

    func connectOnboardingCoordinator() {
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController
        )

        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
        childCoordinators.append(onboardingCoordinator)
    }

    func connectTabBarCoordinator() {
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController
        )

        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
        childCoordinators.append(onboardingCoordinator)
    }
}

extension AppCoordinator: CoordinatorDelegate {
    public func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: true)
    }
}
