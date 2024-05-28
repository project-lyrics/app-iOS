//
//  AppCoordinator.swift
//  Feelin
//
//  Created by Derrick kim on 4/23/24.
//

import UIKit
import CoordinatorAppInterface
import CoordinatorTabBarInterface
import FeatureOnboardingInterface
import CoordinatorOnboardingInterface

final class AppCoordinator: Coordinator {
    var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    init(rootViewController: UINavigationController) {
        self.navigationController = rootViewController
        self.childCoordinators = []
    }
}

extension AppCoordinator {
    func start() {
        let viewController = SplashViewController()
        viewController.coordinator = self
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(viewController, animated: false)
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
        let onboardingCoordinator = TabBarCoordinator(
            navigationController: navigationController
        )

        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
        childCoordinators.append(onboardingCoordinator)
    }

    func didFinish() {
        didFinish(childCoordinator: self)
    }
}

extension AppCoordinator: CoordinatorDelegate, SplashViewControllerDelegate  {
    func didFinish(childCoordinator: Coordinator) {
        navigationController.popToRootViewController(animated: false)
        if childCoordinator is OnboardingCoordinator {
            connectTabBarCoordinator()
        } else {
            connectOnboardingCoordinator()
        }
    }
}
